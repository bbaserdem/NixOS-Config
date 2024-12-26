# Yertengri disk setup
{ config,
  ...
}:
{
  disko.devices.disk = {
    Linux = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-Samsung_SSD_970_PRO_512GB_S463NF0M531040W";
      content = {
        type = "gpt";
        partitions = {
          # This is the EFI partition
          ESP = {
            size = "1G";
            label = "Yertengri_ESP";
            type = "EF00";
            priority = 100;
            content = {
              type = "filesystem";
              format = "vfat";
              extraArgs = [ "-n" "ESP" ];
              mountpoint = "/boot";
              mountOptions = [ "defaults" ];
            };
          };
          # This is the swap partition
          Swap = {
            size = "30G";
            label = "Yertengri_Swap";
            priority = 500;
            content = {
              type = "swap";
              extraArgs = [ "-f" "--label" "Yertengri_Swap" ];
              randomEncryption = true;
              priority = 100;
            };
          };
          # Main OS; BTRFS subvolumes
          Crypt = {
            size = "100%";
            label = "Crypt_Yertengri_Linux";
            priority = 1000;
            content = {
              type = "luks";
              name = "Yertengri_Linux";
              initrdUnlock = true;
              passwordFile = "/tmp/Yertengri.key";
              additionalKeyFiles = [
                "/tmp/Yertengri_Linux.key"
                #config.sops.secrets."joeysaur/crypt-qwerty".path
                #config.sops.secrets."joeysaur/crypt-dvorak".path
              ];
              extraFormatArgs = [ "--label" "Crypt_Yertengri_Linux" ];
              settings = {
                allowDiscards = true;
              };
              content = {
                type = "btrfs";
                extraArgs = [ "--force" "--label" "Yertengri_Linux" ];
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
            label = "Crypt_Yertengri_Data";
            content = {
              type = "luks";
              name = "Yertengri_Data";
              initrdUnlock = false;
              passwordFile = "/tmp/Yertengri.key";
              additionalKeyFiles = [ "/tmp/Yertengri_Data.key" ];
              extraFormatArgs = [ "--label" "Crypt_Yertengri_Data" ];
              settings = {
                allowDiscards = true;
              };
              content = {
                type = "filesystem";
                format = "ext4";
                extraArgs = [ "-L" "Yertengri_Data" ];
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
          ESP = {
            size = "512G";
            label = "System";
            priority = 100;
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
            };
          };
          MSR = {
            size = "16M";
            label = "Microsoft reserved";
            priority = 501;
            type = "0C01";
          };
          Windows = {
            size = "150G";
            label = "Microsoft basic data";
            priority = 502;
            type = "0700";
          };
          Recovery = {
            size = "512M";
            label = "Windows RE";
            priority = 503;
            type = "2700";
          };
          Crypt = {
            size = "100%";
            label = "Crypt_Yertengri_Work";
            priority = 1000;
            content = {
              type = "luks";
              name = "Yertengri_Work";
              initrdUnlock = false;
              passwordFile = "/tmp/Yertengri.key";
              additionalKeyFiles = [ "/tmp/Yertengri_Work.key" ];
              extraFormatArgs = [ "--label" "Crypt_Yertengri_Work" ];
              settings = {
                allowDiscards = true;
              };
              content = {
                type = "filesystem";
                format = "ext4";
                extraArgs = [ "-L" "Yertengri_Work" ];
                mountpoint = "/home/work";
              };
            };
          };
        };
      };
    };
  };
}
