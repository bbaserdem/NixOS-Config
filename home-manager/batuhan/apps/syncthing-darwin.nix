# Syncthing for darwin
{pkgs, ...}: {
  # Disable some folders
  settings.options.folders = {
    media.enable = true;
    sort.enable = false;
    work.enable = false;
    skyfi.enable = true;
    phone.enable = false;
  };

  services.syncthing = {
    # We use systemwide syncthing, don't start a user instance
    enable = true;

    # Secret management, system level
    cert = "/run/secrets.d/1/syncthing/cert";
    key = "/run/secrets.d/1/syncthing/key";
    extraOptions = [
      # This doesn't work
      #"--gui-apikey=$(cat ${config.sops.secrets."syncthing/rest".path})"
    ];

    # Behavior
    overrideFolders = false;
    overrideDevices = true;
    guiAddress = "127.0.0.1:8384";

    settings = {
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
        su-ana = {
          name = "Su Ana";
          id = "5NIUMM2-CXTGG6I-4WMPQZX-L72XJOS-G44OFZI-TZOTPIU-UPOZG37-BFCODAS";
          autoAcceptFolders = true;
        };
        su-ata = {
          name = "Su Ata";
          id = "IGJPOV2-76W3BKB-KC35WIQ-PHIOVTF-6CMMUMN-BNDEAO2-DHS3UMS-PVMEWQ4";
          autoAcceptFolders = true;
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
        skyfi = {
          label = "SkyFi";
          id = "SkyFi_batuhan";
          path = "~/SkyFi";
          type = "sendreceive";
          devices = [
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
