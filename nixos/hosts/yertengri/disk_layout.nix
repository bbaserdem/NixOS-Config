# Yertengri disk setup
{
  disko.devices.disk = {
    main = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-Samsung_SSD_970_PRO_512GB_S463NF0M531040W";
      content = {
        type = "gpt";
        partitions = {
          # This is the EFI partition
          Yertengri_ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["defaults"];
            };
          };
          # This is the swap partition
          Crypt_Yertengri_Swap = {
            size = "30G";
            content = {
              type = "swap";
              randomEncryption = true;
              priority = 100;
            };
          };
          # Main OS; BTRFS subvolumes
          Crypt_Yertengri_Linux = {
            size = "100%";
            content = {
              type = "luks";
              name = "Yertengri_Linux";
              askPassword = true;
              settings = {
                allowDiscards = true;
              };
              additionalKeyFiles = [ "/tmp/Yertengri_Linux.key" ];
              content = {
                type = "btrfs";
                name = "Yertengri_Linux";
                extraArgs = ["-f"];
                subvolumes = {
                  "/@nixos-root" = {
                    mountpoint = "/";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "/@nixos-store" = {
                    mountpoint = "/nix";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "/@nixos-persist" = {
                    mountpoint = "/persist";
                    mountOptions = ["compress=zstd" "strictatime" "lazytime"];
                  };
                  "/@nixos-log" = {
                    mountpoint = "/var/log";
                    mountOptions = ["compress=zstd" "strictatime" "lazytime"];
                  };
                  "/@nixos-machines" = {
                    mountpoint = "/var/lib/machines";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "/@nixos-portables" = {
                    mountpoint = "/var/lib/portables";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "/@home" = {
                    mountpoint = "/home";
                    mountOptions = ["compress=zstd" "strictatime" "lazytime"];
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
      device = "/dev/disk/by-id/nvme-INTEL_SSDPEKNW020T8_PHNH922200QG2P0C";
      content = {
        type = "gpt";
        partitions = {
          # This is for the LUKS space
          Yertengri_Data = {
            size = "100%";
            content = {
              type = "luks";
              name = "Crypt_Yertengri_Data";
              settings = {
                allowDiscards = true;
              };
              content = {
                type = "filesystem";
                name = "Yertengri_Data";
                format = "ext4";
                mountpoint = "/home/data";
              };
            };
          };
        };
      };
    };
    work = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-SHGP31-2000GM_ASB4N718111004R5E";
      content = {
        type = "gpt";
        partitions = {
          System = {
            size = "512G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
            };
          };
          "Microsoft reserved" = {
            size = "16M";
            type = "0C01";
          };
          "Microsoft basic data" = {
            size = "150G";
            type = "0700";
          };
          "Windows RE" = {
            size = "512M";
            type = "2700";
          };
          Yertengri_Work = {
            size = "100%";
            content = {
              type = "luks";
              name = "Crypt_Yertengri_Work";
              askPassword = true;
              settings = {
                allowDiscards = true;
              };
              content = {
                name = "Yertengri_Data";
                type = "filesystem";
                format = "ext4";
                mountpoint = "/home/data";
              };
            };
          };
        };
      };
    };
  };
}
