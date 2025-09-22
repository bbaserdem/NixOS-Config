# Su Ata disk setup
{config, ...}: {
  disko.devices.disk = {
    Linux = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_2TB_S7KHNU0Y703045K";
      content = {
        type = "gpt";
        partitions = {
          # This is the EFI partition
          ESP = {
            size = "1G";
            label = "Su-Ata_ESP";
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
          # This is the swap partition
          Swap = {
            size = "50G";
            label = "Su-Ata_Swap";
            priority = 500;
            content = {
              type = "swap";
              extraArgs = ["-f" "--label" "Su-Ata_Swap"];
              randomEncryption = true;
              priority = 100;
            };
          };
          # Main OS; BTRFS subvolumes
          Linux = {
            size = "100%";
            label = "Su-Ata_Linux";
            priority = 1000;
            content = {
              type = "btrfs";
              extraArgs = ["--force" "--label" "Su-Ata_Linux"];
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
}
