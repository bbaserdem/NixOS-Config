# Yel-Ana disk setup
{config, ...}: {
  disko.devices.disk = {
    Linux = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-CT4000P3PSSD8_2325E6E7A223";
      content = {
        type = "gpt";
        partitions = {
          # This is the EFI partition
          ESP = {
            size = "1G";
            label = "Yel-Ana_ESP";
            type = "EF00";
            priority = 100;
            content = {
              type = "filesystem";
              format = "vfat";
              extraArgs = ["-n" "ESP"];
              mountpoint = "/boot";
              mountOptions = ["defaults"];
            };
          };
          # OS Partition; BTRFS subvolumes
          Crypt_Linux = {
            size = "350G";
            label = "Crypt_Yel-Ana_Linux";
            priority = 1000;
            content = {
              type = "luks";
              name = "Yel-Ana_Linux";
              initrdUnlock = true;
              passwordFile = "/tmp/Yel-Ana_Linux.key";
              additionalKeyFiles = [
                "/tmp/Yel-Ana_Linux.key"
              ];
              extraFormatArgs = ["--label" "Crypt_Yel-Ana_Linux"];
              settings = {
                allowDiscards = true;
              };
              content = {
                type = "btrfs";
                extraArgs = ["--force" "--label" "Yel-Ana_Linux"];
                subvolumes = {
                  "/@nixos-swap" = {
                    mountpoint = "/swap";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
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
          Crypt_Data = {
            size = "100%";
            label = "Crypt_Yel-Ana_Data";
            priority = 1000;
            content = {
              type = "luks";
              name = "Yel-Ana_Data";
              initrdUnlock = true;
              passwordFile = "/tmp/Yel-Ana_Data.key";
              additionalKeyFiles = [
                "/tmp/Yel-Ana_Data.key"
              ];
              extraFormatArgs = ["--label" "Crypt_Yel-Ana_Data"];
              settings = {
                allowDiscards = true;
              };
              content = {
                type = "ext4";
                extraArgs = ["-L" "Yel-Ana_Data"];
                mountpoint = "/home/data";
              };
            };
          };
        };
      };
    };
  };
}
