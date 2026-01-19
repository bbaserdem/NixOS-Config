# Beets configuration
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./settings.nix
  ];

  # Link our plugin from the correct folder
  home.file.".local/share/beets/beetsplug".source = ./beetsplug;

  # Beets config
  programs.beets = {
    enable = lib.mkDefault true;
    package = let
      py = pkgs.unstable.python3.pkgs;
      # Override beets-copyartifacts to version 0.1.6
      beets-copyartifacts-updated = py.beets-copyartifacts.overridePythonAttrs (old: rec {
        version = "0.1.6";
        src = pkgs.fetchFromGitHub {
          owner = "adammillerio";
          repo = "beets-copyartifacts";
          rev = "v${version}";
          hash = "sha256-fMnXuMwxylO9Q7EFPpkgwwNeBuviUa8HduRrqrqdMaI=";
        };
        meta = old.meta // {broken = false;};
        # Disable tests as they're incompatible with newer beets versions
        doCheck = false;
      });
    in
      (py.beets.override {
        pluginOverrides = {
          alternatives = {
            enable = true;
            propagatedBuildInputs = [py.beets-alternatives];
          };
          copyartifacts = {
            enable = true;
            propagatedBuildInputs = [beets-copyartifacts-updated];
          };
        };
      }).overrideAttrs (oldAttrs: {
        # Work around nixpkgs bug where plugin dependencies aren't properly included
        # Also ensure musicbrainzngs is available for MusicBrainz API access
        propagatedBuildInputs =
          oldAttrs.propagatedBuildInputs
          ++ [
            py.beets-alternatives
            beets-copyartifacts-updated
            py.musicbrainzngs
          ];
      });
    mpdIntegration = {
      enableStats = true;
      enableUpdate = true;
    };
  };

  # Tagger
  home.packages = with pkgs; [
    picard
    chromaprint
  ];
}
