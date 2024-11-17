# Configuring syncthing
{
  config,
  pkgs,
  ...
}:
let
  hostsList = [
    "yel-ana"
    "yertengri"
  ];
in {
  services.syncthing = {
    enable = true;
    user = config.myNixOS.defaultUser;
    # Credentials to be set by users
    key = config.sops.secrets."syncthing/key".path;
    cert = config.sops.secrets."syncthing/key".cert;
    # Behavior
    overrideFolders = true;
    overrideDevices = true;
    openDefaultPorts = true;
    guiAddress = "127.0.0.1:8080";
    # Settings for the syncthing service among hosts
    settings = {
      # Runtime options
      options = {
        urAccepted = 1;
        relaysEnabled = true;
        localAnnounceEnabled = true;
      };
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
      };
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
            params = { cleanoutDays = "60"; };
          };
        };
        downloads = {
          label = "Downloads";
          id = "Downloads_batuhan";
          path = "~/Sort/Downloads";
          type = "sendreceive";
          devices = [
            "yel-ana"
            "yertengri"
          ];
          versioning = {
            type = "trashcan";
            params = { cleanoutDays = "10"; };
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
            params = { cleanoutDays = "100"; };
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
            params = { cleanoutDays = "30"; };
          };
        };
      };
    };
    # Relay service
    relay = {
      enable = false;
    };
  };
}
