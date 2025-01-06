# This file defines overlays
# Taken from the stater config here;
# https://github.com/Misterio77/nix-starter-configs
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs {pkgs = final;};

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # Standalone version of Nerd Fonts
    nerdfont-standalone = prev.nerdfonts.override {
      fonts = ["NerdFontsSymbolsOnly"];
    };
    # Create yt-dlp aliases for overrides
    yt-dlp = prev.yt-dlp.override {withAlias = true;};
    # Make NNN use nerdfont symbols
    nnn = prev.nnn.override {withNerdIcons = true;};
    # Add features to ncmpcpp
    ncmpcpp = prev.ncmpcpp.override {
      outputsSupport = true;
      visualizerSupport = true;
      clockSupport = true;
      taglibSupport = true;
    };
    # Add turkish to libreoffice
    libreoffice = prev.libreoffice.override {
      variant = "fresh";
      langs = ["en-US" "tr"];
    };
    # Compile waybar with experimental support built in
    waybar = prev.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
    });
    # Add packages to conda
    conda = prev.conda.override {
      extraPkgs = [
        prev.glib
        prev.xorg.libxcb
        prev.xcb-util-cursor
        prev.libsForQt5.full
        prev.libsForQt5.qt5.qttools
        prev.libsForQt5.qt5.qtbase
        prev.libsForQt5.qt5.qtwayland
        prev.fontconfig
        prev.xorg.libXi
        prev.xorg.libX11
      ];
    };
    # Add external plugins to beets
    beets = prev.beets.override {
      pluginOverrides = {
        alternatives = {
          enable = true;
          propagatedBuildInputs = [prev.beetsPackages.alternatives];
        };
        copyartifacts = {
          enable = true;
          propagatedBuildInputs = [prev.beetsPackages.copyartifacts];
        };
        # Bucket plugin failing test, disable for now for build
        bucket.enable = false;
      };
    };
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
