{
  config,
  lib,
  pkgs,
  ...
}: let
  # Import the let-in variables function
  anyAutoAccept = builtins.any (dev: dev.autoAcceptFolders or false) devices;

  # Get needed lib functions
  inherit (lib) mkOption mkEnableOption types literalMD literalExpression mkPackageOption;

  settingsFormat = pkgs.formats.json {};
in {
  ###### interface
  options = {
    services.syncthing = {
      enable = mkEnableOption "Syncthing, a self-hosted open-source alternative to Dropbox and Bittorrent Sync";

      cert = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Path to the `cert.pem` file, which will be copied into Syncthing's
          [configDir](#opt-services.syncthing.configDir).
        '';
      };

      key = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Path to the `key.pem` file, which will be copied into Syncthing's
          [configDir](#opt-services.syncthing.configDir).
        '';
      };

      overrideDevices = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to delete the devices which are not configured via the
          [devices](#opt-services.syncthing.settings.devices) option.
          If set to `false`, devices added via the web
          interface will persist and will have to be deleted manually.
        '';
      };

      overrideFolders = mkOption {
        type = types.bool;
        default = !anyAutoAccept;
        defaultText = literalMD ''
          `true` unless any device has the
          [autoAcceptFolders](#opt-services.syncthing.settings.devices._name_.autoAcceptFolders)
          option set to `true`.
        '';
        description = ''
          Whether to delete the folders which are not configured via the
          [folders](#opt-services.syncthing.settings.folders) option.
          If set to `false`, folders added via the web
          interface will persist and will have to be deleted manually.
        '';
      };

      settings = mkOption {
        type = types.submodule {
          freeformType = settingsFormat.type;
          options = {
            # global options
            options = mkOption {
              default = {};
              description = ''
                The options element contains all other global configuration options
              '';
              type = types.submodule (
                {name, ...}: {
                  freeformType = settingsFormat.type;
                  options = {
                    localAnnounceEnabled = mkOption {
                      type = types.nullOr types.bool;
                      default = null;
                      description = ''
                        Whether to send announcements to the local LAN, also use such announcements to find other devices.
                      '';
                    };

                    localAnnouncePort = mkOption {
                      type = types.nullOr types.int;
                      default = null;
                      description = ''
                        The port on which to listen and send IPv4 broadcast announcements to.
                      '';
                    };

                    relaysEnabled = mkOption {
                      type = types.nullOr types.bool;
                      default = null;
                      description = ''
                        When true, relays will be connected to and potentially used for device to device connections.
                      '';
                    };

                    urAccepted = mkOption {
                      type = types.nullOr types.int;
                      default = null;
                      description = ''
                        Whether the user has accepted to submit anonymous usage data.
                        The default, 0, mean the user has not made a choice, and Syncthing will ask at some point in the future.
                        "-1" means no, a number above zero means that that version of usage reporting has been accepted.
                      '';
                    };

                    limitBandwidthInLan = mkOption {
                      type = types.nullOr types.bool;
                      default = null;
                      description = ''
                        Whether to apply bandwidth limits to devices in the same broadcast domain as the local device.
                      '';
                    };

                    maxFolderConcurrency = mkOption {
                      type = types.nullOr types.int;
                      default = null;
                      description = ''
                        This option controls how many folders may concurrently be in I/O-intensive operations such as syncing or scanning.
                        The mechanism is described in detail in a [separate chapter](https://docs.syncthing.net/advanced/option-max-concurrency.html).
                      '';
                    };
                  };
                }
              );
            };

            # device settings
            devices = mkOption {
              default = {};
              description = ''
                Peers/devices which Syncthing should communicate with.

                Note that you can still add devices manually, but those changes
                will be reverted on restart if [overrideDevices](#opt-services.syncthing.overrideDevices)
                is enabled.
              '';
              example = {
                bigbox = {
                  id = "7CFNTQM-IMTJBHJ-3UWRDIU-ZGQJFR6-VCXZ3NB-XUH3KZO-N52ITXR-LAIYUAU";
                  addresses = ["tcp://192.168.0.10:51820"];
                };
              };
              type = types.attrsOf (
                types.submodule (
                  {name, ...}: {
                    freeformType = settingsFormat.type;
                    options = {
                      name = mkOption {
                        type = types.str;
                        default = name;
                        description = ''
                          The name of the device.
                        '';
                      };

                      id = mkOption {
                        type = types.str;
                        description = ''
                          The device ID. See <https://docs.syncthing.net/dev/device-ids.html>.
                        '';
                      };

                      autoAcceptFolders = mkOption {
                        type = types.bool;
                        default = false;
                        description = ''
                          Automatically create or share folders that this device advertises at the default path.
                          See <https://docs.syncthing.net/users/config.html?highlight=autoaccept#config-file-format>.
                        '';
                      };
                    };
                  }
                )
              );
            };

            # folder settings
            folders = mkOption {
              default = {};
              description = ''
                Folders which should be shared by Syncthing.

                Note that you can still add folders manually, but those changes
                will be reverted on restart if [overrideFolders](#opt-services.syncthing.overrideFolders)
                is enabled.
              '';
              example = literalExpression ''
                {
                  "/home/user/sync" = {
                    id = "syncme";
                    devices = [ "bigbox" ];
                  };
                }
              '';
              type = types.attrsOf (
                types.submodule (
                  {name, ...}: {
                    freeformType = settingsFormat.type;
                    options = {
                      enable = mkOption {
                        type = types.bool;
                        default = true;
                        description = ''
                          Whether to share this folder.
                          This option is useful when you want to define all folders
                          in one place, but not every machine should share all folders.
                        '';
                      };

                      path = mkOption {
                        # TODO for release 23.05: allow relative paths again and set
                        # working directory to cfg.dataDir
                        type =
                          types.str
                          // {
                            check = x: types.str.check x && (substring 0 1 x == "/" || substring 0 2 x == "~/");
                            description = types.str.description + " starting with / or ~/";
                          };
                        default = name;
                        description = ''
                          The path to the folder which should be shared.
                          Only absolute paths (starting with `/`) and paths relative to
                          the [user](#opt-services.syncthing.user)'s home directory
                          (starting with `~/`) are allowed.
                        '';
                      };

                      id = mkOption {
                        type = types.str;
                        default = name;
                        description = ''
                          The ID of the folder. Must be the same on all devices.
                        '';
                      };

                      label = mkOption {
                        type = types.str;
                        default = name;
                        description = ''
                          The label of the folder.
                        '';
                      };

                      type = mkOption {
                        type = types.enum [
                          "sendreceive"
                          "sendonly"
                          "receiveonly"
                          "receiveencrypted"
                        ];
                        default = "sendreceive";
                        description = ''
                          Controls how the folder is handled by Syncthing.
                          See <https://docs.syncthing.net/users/config.html#config-option-folder.type>.
                        '';
                      };

                      devices = mkOption {
                        type = types.listOf (
                          types.oneOf [
                            types.str
                            (types.submodule (
                              {...}: {
                                freeformType = settingsFormat.type;
                                options = {
                                  name = mkOption {
                                    type = types.str;
                                    default = null;
                                    description = ''
                                      The name of a device defined in the
                                      [devices](#opt-services.syncthing.settings.devices)
                                      option.
                                    '';
                                  };
                                  encryptionPasswordFile = mkOption {
                                    type = types.nullOr (
                                      types.pathWith {
                                        inStore = false;
                                        absolute = true;
                                      }
                                    );
                                    default = null;
                                    description = ''
                                      Path to encryption password. If set, the file will be read during
                                      service activation, without being embedded in derivation.
                                    '';
                                  };
                                };
                              }
                            ))
                          ]
                        );
                        default = [];
                        description = ''
                          The devices this folder should be shared with. Each device must
                          be defined in the [devices](#opt-services.syncthing.settings.devices) option.

                          A list of either strings or attribute sets, where values
                          are device names or device configurations.
                        '';
                      };

                      versioning = mkOption {
                        default = null;
                        description = ''
                          How to keep changed/deleted files with Syncthing.
                          There are 4 different types of versioning with different parameters.
                          See <https://docs.syncthing.net/users/versioning.html>.
                        '';
                        example = literalExpression ''
                          [
                            {
                              versioning = {
                                type = "simple";
                                params.keep = "10";
                              };
                            }
                            {
                              versioning = {
                                type = "trashcan";
                                params.cleanoutDays = "1000";
                              };
                            }
                            {
                              versioning = {
                                type = "staggered";
                                fsPath = "/syncthing/backup";
                                params = {
                                  cleanInterval = "3600";
                                  maxAge = "31536000";
                                };
                              };
                            }
                            {
                              versioning = {
                                type = "external";
                                params.versionsPath = pkgs.writers.writeBash "backup" '''
                                  folderpath="$1"
                                  filepath="$2"
                                  rm -rf "$folderpath/$filepath"
                                ''';
                              };
                            }
                          ]
                        '';
                        type = with types;
                          nullOr (submodule {
                            freeformType = settingsFormat.type;
                            options = {
                              type = mkOption {
                                type = enum [
                                  "external"
                                  "simple"
                                  "staggered"
                                  "trashcan"
                                ];
                                description = ''
                                  The type of versioning.
                                  See <https://docs.syncthing.net/users/versioning.html>.
                                '';
                              };
                            };
                          });
                      };

                      copyOwnershipFromParent = mkOption {
                        type = types.bool;
                        default = false;
                        description = ''
                          On Unix systems, tries to copy file/folder ownership from the parent directory (the directory it's located in).
                          Requires running Syncthing as a privileged user, or granting it additional capabilities (e.g. CAP_CHOWN on Linux).
                        '';
                      };
                    };
                  }
                )
              );
            };
          };
        };
        default = {};
        description = ''
          Extra configuration options for Syncthing.
          See <https://docs.syncthing.net/users/config.html>.
          Note that this attribute set does not exactly match the documented
          xml format. Instead, this is the format of the json rest api. There
          are slight differences. For example, this xml:
          ```xml
          <options>
            <listenAddress>default</listenAddress>
            <minHomeDiskFree unit="%">1</minHomeDiskFree>
          </options>
          ```
          corresponds to the json:
          ```json
          {
            options: {
              listenAddresses = [
                "default"
              ];
              minHomeDiskFree = {
                unit = "%";
                value = 1;
              };
            };
          }
          ```
        '';
        example = {
          options.localAnnounceEnabled = false;
          gui.theme = "black";
        };
      };

      guiAddress = mkOption {
        type = types.str;
        default = "127.0.0.1:8384";
        description = ''
          The address to serve the web interface at.
        '';
      };

      systemService = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to auto-launch Syncthing as a system service.
        '';
      };

      user = mkOption {
        type = types.str;
        default = letVars.defaultUser;
        example = "yourUser";
        description = ''
          The user to run Syncthing as.
          By default, a user named `${letVars.defaultUser}` will be created whose home
          directory is [dataDir](#opt-services.syncthing.dataDir).
        '';
      };

      group = mkOption {
        type = types.str;
        default = letVars.defaultGroup;
        example = "yourGroup";
        description = ''
          The group to run Syncthing under.
          By default, a group named `${letVars.defaultGroup}` will be created.
        '';
      };

      all_proxy = mkOption {
        type = with types; nullOr str;
        default = null;
        example = "socks5://address.com:1234";
        description = ''
          Overwrites the all_proxy environment variable for the Syncthing process to
          the given value. This is normally used to let Syncthing connect
          through a SOCKS5 proxy server.
          See <https://docs.syncthing.net/users/proxying.html>.
        '';
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/syncthing";
        example = "/home/yourUser";
        description = ''
          The path where synchronised directories will exist.
        '';
      };

      configDir = let
        cfg = config.services.syncthing;
        opt = options.services.syncthing;
        cond = lib.versionAtLeast config.system.stateVersion "19.03";
      in
        mkOption {
          type = types.path;
          description = ''
            The path where the settings and keys will exist.
          '';
          default = cfg.dataDir + lib.optionalString cond "/.config/syncthing";
          defaultText = literalMD ''
            * if `stateVersion >= 19.03`:

                  config.${opt.dataDir} + "/.config/syncthing"
            * otherwise:

                  config.${opt.dataDir}
          '';
        };

      databaseDir = mkOption {
        type = types.path;
        description = ''
          The directory containing the database and logs.
        '';
        default = config.services.syncthing.configDir;
        defaultText = literalExpression "config.services.syncthing.configDir";
      };

      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [];
        example = ["--reset-deltas"];
        description = ''
          Extra flags passed to the syncthing command in the service definition.
        '';
      };

      openDefaultPorts = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = ''
          Whether to open the default ports in the firewall: TCP/UDP 22000 for transfers
          and UDP 21027 for discovery.

          If multiple users are running Syncthing on this machine, you will need
          to manually open a set of ports for each instance and leave this disabled.
          Alternatively, if you are running only a single instance on this machine
          using the default ports, enable this.
        '';
      };

      package = mkPackageOption pkgs "syncthing" {};
    };
  };

  imports =
    [
      (lib.mkRemovedOptionModule ["services" "syncthing" "useInotify"] ''
        This option was removed because Syncthing now has the inotify functionality included under the name "fswatcher".
        It can be enabled on a per-folder basis through the web interface.
      '')
      (
        lib.mkRenamedOptionModule
        ["services" "syncthing" "extraOptions"]
        ["services" "syncthing" "settings"]
      )
      (
        lib.mkRenamedOptionModule
        ["services" "syncthing" "folders"]
        ["services" "syncthing" "settings" "folders"]
      )
      (
        lib.mkRenamedOptionModule
        ["services" "syncthing" "devices"]
        ["services" "syncthing" "settings" "devices"]
      )
      (
        lib.mkRenamedOptionModule
        ["services" "syncthing" "options"]
        ["services" "syncthing" "settings" "options"]
      )
    ]
    ++ map
    (o: lib.mkRenamedOptionModule ["services" "syncthing" "declarative" o] ["services" "syncthing" o])
    [
      "cert"
      "key"
      "devices"
      "folders"
      "overrideDevices"
      "overrideFolders"
      "extraOptions"
    ];
}
