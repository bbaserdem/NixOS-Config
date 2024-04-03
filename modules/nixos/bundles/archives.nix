# archives.nix
# A program list of archiving utilities

{ pkgs, lib, config, ... }: {

  options = {
    archives.enable = 
      lib.mkEnableOption "Enables archives";
  };

  config = lib.mkIf config.archives.enable {
    environment.systemPackages = with pkgs [
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
