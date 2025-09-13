# Beets configuration
{
  config,
  pkgs,
  lib,
  ...
}: {
  # Link our plugin from the correct folder
  home.file.".local/share/beets/beetsplug".source = ./beetsplug;

  # Beets config
  programs.beets = {
    enable = lib.mkDefault true;
    mpdIntegration = {
      enableStats = true;
      enableUpdate = true;
    };

    settings = (import ./beetsSettings.nix) {inherit config pkgs;};
  };

  # Tagger
  home.packages = with pkgs; [
    picard
    chromaprint
  ];
}
