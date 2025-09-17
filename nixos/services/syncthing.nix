# Configuring syncthing
{
  config,
  pkgs,
  ...
}: let
  hostsList = [
    "yel-ana"
    "yertengri"
  ];
in {
  services.syncthing = {
    # Syncthing runs for main user
    enable = true;
    user = config.myNixOS.userName;

    # Credentials to be set by users
    key = config.sops.secrets."syncthing/key".path;
    cert = config.sops.secrets."syncthing/cert".path;
    extraFlags = [
      # This doesn't work
      #"--gui-apikey=$(cat ${config.sops.secrets."syncthing/rest".path})"
    ];

    # Behavior
    overrideFolders = false;
    overrideDevices = true;
    openDefaultPorts = true;
    guiAddress = "127.0.0.1:8384";

    # Relay service
    relay = {
      enable = false;
    };

    # Settings for the syncthing service among hosts
    settings = {
      # Runtime options
      options = {
        urAccepted = 3;
        relaysEnabled = true;
        localAnnounceEnabled = true;
      };

      # Public IDs of all users
      devices = {
        yel-ana = {
          name = "Yel Ana";
          id = "DRKKHJC-XAHARAB-JEMMSOW-4IU2OAH-6NMU6SI-DTVDCD2-2RLUPX2-EWQNHQN";
          autoAcceptFolders = true;
        };
        yertengri = {
          name = "Yertengri";
          id = "JGK6FDM-ALFF5XB-XEHIJSU-ZKZ2UVA-WYB2VLA-X4ETL3B-Q77ZL5D-OFGSGAL";
          autoAcceptFolders = true;
        };
        erlik = {
          name = "Erlik";
          id = "DTELBJI-F7UOJXY-5DCXOKU-EL3DHZC-S7S7K4H-AFLV3KD-HBSNRUY-W6QOEQH";
          autoAcceptFolders = false;
        };
        # Need su-ana and su-ata
      };

      # Folder layout
      folders = {
        media = {
          label = "Media";
          id = "Media_batuhan";
          path = "~/Media";
          type = "sendreceive";
          devices = [
            "yel-ana"
            "yertengri"
          ];
          versioning = {
            type = "trashcan";
            params = {cleanoutDays = "60";};
          };
        };
        sort = {
          label = "Sort";
          id = "Sort_batuhan";
          path = "~/Sort";
          type = "sendreceive";
          devices = [
            "yel-ana"
            "yertengri"
          ];
          versioning = {
            type = "trashcan";
            params = {cleanoutDays = "10";};
          };
        };
        work = {
          label = "Work";
          id = "Work_batuhan";
          path = "~/Work";
          type = "sendreceive";
          devices = [
            "yel-ana"
            "yertengri"
          ];
          versioning = {
            type = "trashcan";
            params = {cleanoutDays = "100";};
          };
        };
        phone = {
          label = "Android";
          id = "Android_batuhan";
          path = "~/Shared/Android";
          type = "sendreceive";
          devices = [
            "yel-ana"
            "yertengri"
            "erlik"
          ];
          versioning = {
            type = "trashcan";
            params = {cleanoutDays = "30";};
          };
        };
      };
    };
  };
}
