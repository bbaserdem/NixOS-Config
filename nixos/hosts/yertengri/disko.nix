# umay disk setup
# https://github.com/nix-community/disko/blob/master/example/luks-btrfs-subvolumes.nix

{
  main-device ? throw "Set this to your OS disk device, e.g. /dev/sda",
  data-device ? throw "Set this to your data disk device, e.g. /dev/sda",
  ...
}: {
  disko.devices.disk = {
    main = {
      type = "disk";
      device = main-device;
      content = {
        type = "gpt";
        partitions = {
          # This is the EFI partition
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "defaults" ];
            };
          };
          # Swap partition in separate LUKS as swapfiles are not preferred
          Swap = {
            size = "45G";
            content = {
              type = "luks";
              name = "Crypt-Home-Sway";
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };
          };
          # Main OS; BTRFS subvolumes
          Luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "Crypt-Home-Main";
                # disable settings.keyFile if you want to use interactive password entry
                #passwordFile = "/tmp/secret.key"; # Interactive
              settings = {
                allowDiscards = true;
                #keyFile = "/tmp/secret.key";
              };
              #additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                    "/@nix-root" = {
                      mountpoint = "/";
                      mountOptions = [ "compress=zstd" "lazytime" "strictatime" ];
                    };
                    "/@home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "compress=zstd"
                        "lazytime"
                        "strictatime"
                        "user_subvol_rm_allowed"
                      ];
                    };
                    "/@nix-store" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "compress=zstd"
                        "lazytime"
                        "strictatime"
                      ];
                    };
                    "/@nix-snapshots" = {
                      mountpoint = "/.snapshots";
                      mountOptions = [
                        "compress=zstd"
                        "lazytime"
                        "strictatime"
                      ];
                    };
                  };
                mountpoint = "/mnt/filesystem";
                mountOptions = [
                  "compress=zstd"
                  "lazytime"
                  "strictatime"
                ];
              };
            };
          };
        };
      };
    };
    data = {
      type = "disk";
      device = data-device;
      content = {
        type = "gpt";
        partitions = {
          # This is for the LUKS space 
          Luks = {
            size = "1.5T";
            content = {
              type = "luks";
              name = "Crypt-Home-Data";
              settings = {
                allowDiscards = true;
                #keyFile = "/tmp/secret.key";
              };
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/home/data";
              };
            };
          };
          Windows = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ntfs";
            };
          };
        };
      };
    };
  };
}
