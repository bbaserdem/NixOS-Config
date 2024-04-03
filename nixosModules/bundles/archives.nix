# archives.nix
# A program list of archiving utilities

{ pkgs, lib, config, ... }: 
with lib;
let cfg = config.myNixOS.bundles.archives;
in {
  options.myNixOS = {
    # option = lib.mkOption {
    #   default = "";
    # description = "Some option";
    # };
  };
  # Install archiving tools into userspace 
  config = {
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
  };
}
