# Od Ata disk setup
{
  config,
  lib,
  ...
}: {
  disko.devices.disk.Linux = {
    type = "disk";
    device = "/dev/disk/by-id/mmc-ED2S5_0xb8cb6881";
    content = {
      type = "gpt";
      partitions = {
        # Firmware partition
        FIRMWARE = {
          size = "1024M";
          label = "FIRMWARE";
          type = "0700"; # Microsoft basic data
          priority = 1;
          attributes = [
            0 # Required partition
          ];
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot/firmware";
            mountOptions = [
              "noatime"
              "noauto"
              "x-systemd.automount"
              "x-systemd.idle-timeout=1min"
            ];
          };
        };

        # This is the EFI partition
        ESP = {
          size = "1G";
          label = "Od-Ata_ESP";
          type = "EF00";
          priority = 100;
          attributes = [
            2 # Legacy BIOS Bootable, for U-Boot to find extlinux config
          ];
          content = {
            type = "filesystem";
            format = "vfat";
            extraArgs = [
              "-n"
              "ESP"
            ];
            mountpoint = "/boot";
            mountOptions = [
              "noatime"
              "noauto"
              "x-systemd.automount"
              "x-systemd.idle-timeout=1min"
              "umask=0077"
            ];
          };
        };

        Swap = {
          type = "0200"; # Linux swap
          size = "9G"; # RAM + 1G
          content = {
            type = "swap";
            resumeDevice = true; # hibernation swap
            # Only to be used when zram swap is pressured
            priority = 2;
          };
        };

        # Main OS; btrfs
        Linux = {
          type = "8305"; # Linux ARM64 root (/)
          size = "100%";
          label = "Od-Ata_Linux";
          priority = 1000;
          content = {
            type = "btrfs";
            extraArgs = [
              "--label Od-Ata_Linux"
              "-f" # Override existing partition
            ];
            postCreateHook = let
              thisBtrfs = config.disko.devices.disk.Linux.content.partitions.Linux.content;
              device = thisBtrfs.device;
              subvolumes = thisBtrfs.subvolumes;
              makeBlankSnapshot = btrfsMntPoint: subvol: let
                subvolAbsPath = lib.strings.normalizePath "${btrfsMntPoint}/${subvol.name}";
                dst = "${subvolAbsPath}-blank";
                # NOTE: this one-liner has the same functionality (inspired by zfs hook)
                # btrfs subvolume list -s mnt/rootfs | grep -E ' rootfs-blank$' || btrfs subvolume snapshot -r mnt/rootfs mnt/rootfs-blank
              in ''
                if ! btrfs subvolume show "${dst}" > /dev/null 2>&1; then
                  btrfs subvolume snapshot -r "${subvolAbsPath}" "${dst}"
                fi
              '';
              # Mount top-level subvolume (/) with "subvol=/", without it
              # the default subvolume will be mounted. They're the same in
              # this case, though. So "subvol=/" isn't really necessary
            in ''
              MNTPOINT=$(mktemp -d)
              mount ${device} "$MNTPOINT" -o subvol=/
              trap 'umount $MNTPOINT; rm -rf $MNTPOINT' EXIT
              ${makeBlankSnapshot "$MNTPOINT" subvolumes."/rootfs"}
            '';
            subvolumes = {
              "/rootfs" = {
                mountpoint = "/";
                mountOptions = ["noatime"];
              };
              "/nix" = {
                mountpoint = "/nix";
                mountOptions = ["noatime"];
              };
              "/home" = {
                mountpoint = "/home";
                mountOptions = ["noatime"];
              };
              "/log" = {
                mountpoint = "/var/log";
                mountOptions = ["noatime"];
              };
              "/swap" = {
                mountpoint = "/.swapvol";
                swap."swapfile" = {
                  size = "8G";
                  priority = 3;
                };
              };
            };
          };
        };
      };
    };
  };
}
