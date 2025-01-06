# Beets configuration
{
  config,
  pkgs,
  lib,
  ...
}: rec {
  # Link our plugin from the correct folder
  home.file.".local/share/beets/beetsplug".source = ./beetsplug;

  # Beets config
  programs.beets = {
    enable = lib.mkDefault true;
    mpdIntegration = {
      enableStats = true;
      enableUpdate = true;
    };
    # Bucket plugin test failing, disable with overlay
    settings = (import ./settings.nix) {inherit config;};
  };
}
