# Configuring syncthing
{
  config,
  pkgs,
  arch,
  lib,
  ...
}: {
  # Make this module agnostic to home-manager vs system module loading.
  services.syncthing =
    (
      if lib.hasSuffix "-darwin" arch
      then {}
      else {
        # Only in nixos options
        user = config.myNixOS.userName;
        openDefaultPorts = true;

        # Relay service
        relay = {enable = false;};
      }
    )
    // {
      # Options both in nixos and in home-manager

      # Syncthing runs for main user
      enable = true;

      # Credentials to be set by users
      key = config.sops.secrets."syncthing/key".path;
      cert = config.sops.secrets."syncthing/cert".path;

      # Behavior
      overrideFolders = true;
      overrideDevices = true;
      guiAddress = "127.0.0.1:8384";

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
            autoAcceptFolders = false;
          };
          yertengri = {
            name = "Yertengri";
            id = "JGK6FDM-ALFF5XB-XEHIJSU-ZKZ2UVA-WYB2VLA-X4ETL3B-Q77ZL5D-OFGSGAL";
            autoAcceptFolders = false;
          };
          erlik = {
            name = "Erlik";
            id = "DTELBJI-F7UOJXY-5DCXOKU-EL3DHZC-S7S7K4H-AFLV3KD-HBSNRUY-W6QOEQH";
            autoAcceptFolders = false;
          };
          su-ana = {
            name = "Su Ana";
            id = "5NIUMM2-CXTGG6I-4WMPQZX-L72XJOS-G44OFZI-TZOTPIU-UPOZG37-BFCODAS";
            autoAcceptFolders = false;
          };
          su-ata = {
            name = "Su Ata";
            id = "IGJPOV2-76W3BKB-KC35WIQ-PHIOVTF-6CMMUMN-BNDEAO2-DHS3UMS-PVMEWQ4";
            autoAcceptFolders = false;
          };
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
              "su-ana"
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
              "su-ana"
              "su-ata"
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
