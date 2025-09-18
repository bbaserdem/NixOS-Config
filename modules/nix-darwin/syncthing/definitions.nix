{
  config,
  lib,
  options,
  pkgs,
  ...
}: let
  # Input parameters
  cfg = config.services.syncthing;
  opt = options.services.syncthing;

  # Function to generate all the let-in variables
  mkSyncthingLetVars = {
    # Required parameters
    config,
    lib,
    options,
    pkgs,
    # Optional overrides
    defaultUser ? "syncthing",
    defaultGroup ? null, # Will default to defaultUser if null
  }: let
    actualDefaultGroup =
      if defaultGroup != null
      then defaultGroup
      else defaultUser;
    cfg = config.services.syncthing;
    opt = options.services.syncthing;
  in {
    inherit cfg opt;

    defaultUser = defaultUser;
    defaultGroup = actualDefaultGroup;

    settingsFormat = pkgs.formats.json {};

    cleanedConfig = lib.converge (lib.filterAttrsRecursive (_: v: v != null && v != {})) cfg.settings;

    isUnixGui = (builtins.substring 0 1 cfg.guiAddress) == "/";

    # Syncthing supports serving the GUI over Unix sockets. If that happens, the
    # API is served over the Unix socket as well.  This function returns the correct
    # curl arguments for the address portion of the curl command for both network
    # and Unix socket addresses.
    curlAddressArgs = path:
      if isUnixGui
      # if cfg.guiAddress is a unix socket, tell curl explicitly about it
      # note that the dot in front of `${path}` is the hostname, which is
      # required.
      then "--unix-socket ${cfg.guiAddress} http://.${path}"
      # no adjustments are needed if cfg.guiAddress is a network address
      else "${cfg.guiAddress}${path}";

    devices =
      lib.mapAttrsToList (
        _: device:
          device
          // {
            deviceID = device.id;
          }
      )
      cfg.settings.devices;

    anyAutoAccept = builtins.any (dev: dev.autoAcceptFolders) devices;

    folders = lib.mapAttrsToList (
      folderName: folder:
        folder
        // lib.throwIf (folder ? rescanInterval || folder ? watch || folder ? watchDelay)
        ''
          The options services.syncthing.settings.folders.<name>.{rescanInterval,watch,watchDelay}
          were removed. Please use, respectively, {rescanIntervalS,fsWatcherEnabled,fsWatcherDelayS} instead.
        ''
        {
          devices = let
            folderDevices = folder.devices;
          in
            map (
              device:
                if builtins.isString device
                then {deviceId = cfg.settings.devices.${device}.id;}
                else if builtins.isAttrs device
                then {deviceId = cfg.settings.devices.${device.name}.id;} // device
                else throw "Invalid type for devices in folder '${folderName}'; expected list or attrset."
            )
            folderDevices;
        }
    ) (lib.filterAttrs (_: folder: folder.enable) cfg.settings.folders);

    jq = "${pkgs.jq}/bin/jq";

    updateConfig = pkgs.writers.writeBash "merge-syncthing-config" (
      ''
        set -efu

        # be careful not to leak secrets in the filesystem or in process listings
        umask 0077

        curl() {
            # get the api key by parsing the config.xml
            while
                ! ${pkgs.libxml2}/bin/xmllint \
                    --xpath 'string(configuration/gui/apikey)' \
                    ${cfg.configDir}/config.xml \
                    >"$RUNTIME_DIRECTORY/api_key"
            do sleep 1; done
            (printf "X-API-Key: "; cat "$RUNTIME_DIRECTORY/api_key") >"$RUNTIME_DIRECTORY/headers"
            ${pkgs.curl}/bin/curl -sSLk -H "@$RUNTIME_DIRECTORY/headers" \
                --retry 1000 --retry-delay 1 --retry-all-errors \
                "$@"
        }
      ''
      +
      /*
      Syncthing's rest API for the folders and devices is almost identical.
      Hence we iterate them using lib.pipe and generate shell commands for both at
      the same time.
      */
      (
        lib.pipe
        {
          # The attributes below are the only ones that are different for devices /
          # folders.
          devs = {
            new_conf_IDs = map (v: v.id) devices;
            GET_IdAttrName = "deviceID";
            override = cfg.overrideDevices;
            conf = devices;
            baseAddress = curlAddressArgs "/rest/config/devices";
          };
          dirs = {
            new_conf_IDs = map (v: v.id) folders;
            GET_IdAttrName = "id";
            override = cfg.overrideFolders;
            conf = folders;
            baseAddress = curlAddressArgs "/rest/config/folders";
          };
        }
        [
          # Now for each of these attributes, write the curl commands that are
          # identical to both folders and devices.
          (lib.mapAttrs (
            conf_type: s:
            # We iterate the `conf` list now, and run a curl -X POST command for each, that
            # should update that device/folder only.
              lib.pipe s.conf [
                # Quoting https://docs.syncthing.net/rest/config.html:
                #
                # > PUT takes an array and POST a single object. In both cases if a
                # given folder/device already exists, it's replaced, otherwise a new
                # one is added.
                #
                # What's not documented, is that using PUT will remove objects that
                # don't exist in the array given. That's why we use here `POST`, and
                # only if s.override == true then we DELETE the relevant folders
                # afterwards.
                (map (
                  new_cfg: let
                    jsonPreSecretsFile = pkgs.writeTextFile {
                      name = "${conf_type}-${new_cfg.id}-conf-pre-secrets.json";
                      text = builtins.toJSON new_cfg;
                    };
                    injectSecretsJqCmd =
                      {
                        # There are no secrets in `devs`, so no massaging needed.
                        "devs" = "${jq} .";
                        "dirs" = let
                          folder = new_cfg;
                          devicesWithSecrets = lib.pipe folder.devices [
                            (lib.filter (device: (builtins.isAttrs device) && device ? encryptionPasswordFile))
                            (map (device: {
                              deviceId = device.deviceId;
                              variableName = "secret_${builtins.hashString "sha256" device.encryptionPasswordFile}";
                              secretPath = device.encryptionPasswordFile;
                            }))
                          ];
                          # At this point, `jsonPreSecretsFile` looks something like this:
                          #
                          #   {
                          #     ...,
                          #     "devices": [
                          #       {
                          #         "deviceId": "id1",
                          #         "encryptionPasswordFile": "/etc/bar-encryption-password",
                          #         "name": "..."
                          #       }
                          #     ],
                          #   }
                          #
                          # We now generate a `jq` command that can replace those
                          # `encryptionPasswordFile`s with `encryptionPassword`.
                          # The `jq` command ends up looking like this:
                          #
                          #   jq --rawfile secret_DEADBEEF /etc/bar-encryption-password '
                          #     .devices[] |= (
                          #       if .deviceId == "id1" then
                          #         del(.encryptionPasswordFile) |
                          #         .encryptionPassword = $secret_DEADBEEF
                          #       else
                          #         .
                          #       end
                          #     )
                          #   '
                          jqUpdates =
                            map (device: ''
                              .devices[] |= (
                                if .deviceId == "${device.deviceId}" then
                                  del(.encryptionPasswordFile) |
                                  .encryptionPassword = ''$${device.variableName}
                                else
                                  .
                                end
                              )
                            '')
                            devicesWithSecrets;
                          jqRawFiles =
                            map (
                              device: "--rawfile ${device.variableName} ${lib.escapeShellArg device.secretPath}"
                            )
                            devicesWithSecrets;
                        in "${jq} ${lib.concatStringsSep " " jqRawFiles} ${
                          lib.escapeShellArg (lib.concatStringsSep "|" (["."] ++ jqUpdates))
                        }";
                      }
                      .${
                        conf_type
                      };
                  in ''
                    ${injectSecretsJqCmd} ${jsonPreSecretsFile} | curl --json @- -X POST ${s.baseAddress}
                  ''
                ))
                (lib.concatStringsSep "\n")
              ]
              /*
              If we need to override devices/folders, we iterate all currently configured
              IDs, via another `curl -X GET`, and we delete all IDs that are not part of
              the Nix configured list of IDs
              */
              + lib.optionalString s.override ''
                stale_${conf_type}_ids="$(curl -X GET ${s.baseAddress} | ${jq} \
                  --argjson new_ids ${lib.escapeShellArg (builtins.toJSON s.new_conf_IDs)} \
                  --raw-output \
                  '[.[].${s.GET_IdAttrName}] - $new_ids | .[]'
                )"
                for id in ''${stale_${conf_type}_ids}; do
                  >&2 echo "Deleting stale device: $id"
                  curl -X DELETE ${s.baseAddress}/$id
                done
              ''
          ))
          builtins.attrValues
          (lib.concatStringsSep "\n")
        ]
      )
      +
      /*
      Now we update the other settings defined in cleanedConfig which are not
      "folders" or "devices".
      */
      (lib.pipe cleanedConfig [
        builtins.attrNames
        (lib.subtractLists [
          "folders"
          "devices"
        ])
        (map (subOption: ''
          curl -X PUT -d ${
            lib.escapeShellArg (builtins.toJSON cleanedConfig.${subOption})
          } ${curlAddressArgs "/rest/config/${subOption}"}
        ''))
        (lib.concatStringsSep "\n")
      ])
      + ''
        # restart Syncthing if required
        if curl ${curlAddressArgs "/rest/config/restart-required"} |
           ${jq} -e .requiresRestart > /dev/null; then
            curl -X POST ${curlAddressArgs "/rest/system/restart"}
        fi
      ''
    );
  };
in
  mkSyncthingLetVars
