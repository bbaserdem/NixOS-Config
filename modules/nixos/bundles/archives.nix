# archives.nix
# A program list of archiving utilities

{ pkgs, lib, config, ... }: 
with lib;
let cfg = config.bundles.archives;
in {

  options.bundles.archive = {
    enable = lib.mkEnableOption "Enables installing archives";
  };

  config = mkIf cfg.enable {
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
