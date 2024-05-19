# archives.nix
# A program list of archiving utilities
{
  pkgs,
  lib,
  config,
  ...
}: {
  # Install archiving tools into userspace
  environment.systemPackages = with pkgs; [
    patool
    zip
    bzip2
    bzip3
    p7zip
    ncompress
    gzip
    rar
    unrar
    rzip
    gnutar
    xz
    zstd
  ];
}
