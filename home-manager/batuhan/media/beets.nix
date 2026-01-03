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
        meta = old.meta // { broken = false; };
        # Disable tests as they're incompatible with newer beets versions
        doCheck = false;
      });
      # Override beets-alternatives to version 0.14.0
      beets-alternatives-updated = py.beets-alternatives.overridePythonAttrs (old: rec {
        version = "0.14.0";
        src = pkgs.fetchFromGitHub {
          owner = "geigerzaehler";
          repo = "beets-alternatives";
          rev = "v${version}";
          hash = "sha256-leZYXf6Oo/jAKbnJbP+rTnuRsh9P1BQXYAbthMNT60A=";
        };
        # Remove patches since the fix should be mainlined in v0.14.0
        patches = [];
        # v0.14.0 uses hatchling as build system
        build-system = [py.hatchling];
      });
    in
      (py.beets.override {
        pluginOverrides = {
          alternatives = {
            enable = true;
            propagatedBuildInputs = [beets-alternatives-updated];
          };
          copyartifacts = {
            enable = true;
            propagatedBuildInputs = [beets-copyartifacts-updated];
          };
        };
      }).overrideAttrs (oldAttrs: {
        # Work around nixpkgs bug where plugin dependencies aren't properly included
        propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [
          beets-alternatives-updated
          beets-copyartifacts-updated
        ];
      });
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
