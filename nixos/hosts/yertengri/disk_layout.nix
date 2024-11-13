# Yertengri disk setup
{
  disko.devices.Yertengri = {
    Linux = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-Samsung_SSD_970_PRO_512GB_S463NF0M531040W";
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
              mountOptions = ["defaults"];
            };
          };
          # This is the swap partition
          Crypt-Swap = {
            size = "30G";
            content = {
              type = "swap";
              randomEncryption = true;
              priority = 100;
            };
          };
          # Main OS; BTRFS subvolumes
          Crypt = {
            size = "100%";
            content = {
              type = "luks";
              name = "Yertengri-Linux";
              askPassword = true;
              settings = {
                allowDiscards = true;
              };
              additionalKeyFiles = [ "/tmp/Yertengri-Linux.key" ];
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
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
    Data = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-INTEL_SSDPEKNW020T8_PHNH922200QG2P0C";
      content = {
        type = "gpt";
        partitions = {
          # This is for the LUKS space
          Crypt = {
            size = "100%";
            content = {
              type = "luks";
              name = "Yertengri-Data";
              settings = {
                allowDiscards = true;
              };
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/home/data";
              };
            };
          };
        };
      };
    };
    Work = {
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
          Crypt = {
            size = "100%";
            content = {
              type = "luks";
              name = "Yertengri-Work";
              askPassword = true;
              settings = {
                allowDiscards = true;
              };
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/home/work";
              };
            };
          };
        };
      };
    };
  };
}
