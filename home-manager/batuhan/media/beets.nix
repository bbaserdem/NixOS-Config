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
    package = pkgs.python3.pkgs.beets.override {
      pluginOverrides = {
        alternatives = {
          enable = true;
          propagatedBuildInputs = [pkgs.python3Packages.beets-alternatives];
        };
        # TODO: Marked as broken, fix this
        # copyartifacts = {
        #   enable = true;
        #   propagatedBuildInputs = [pkgs.python3Packages.beets-copyartifacts];
        # };
      };
    };
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
