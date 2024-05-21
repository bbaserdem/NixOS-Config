# filesystems.nix
# A program list of filesystems I plan to support
{
  pkgs,
  lib,
  config,
  ...
}: {
  # Install archiving tools into userspace
  environment.systemPackages = with pkgs; [
    btrfs-progs
    unstable.btrfs-assistant
    btrfs-heatmap
    snapper
    e2fsprogs
    ntfs3g
    parted
    gparted
    gptfdisk
    sshfs
  ];
}
