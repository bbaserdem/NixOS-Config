# This file defines overlays
# Taken from the stater config here;
# https://github.com/Misterio77/nix-starter-configs
{
  inputs,
  outputs,
  ...
}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: prev: import ../pkgs {pkgs = final;};

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

    # # Add external plugins to beets
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

    # Add different variants of the cattpuccin packages
    catppuccin-mocha-sddm = prev.catppuccin-sddm.override {
      flavor = "mocha";
      font = "Noto Sans";
      fontSize = "16";
    };
    catppuccin-sapphire-mocha-kvantum = prev.catppuccin-kvantum.override {
      accent = "sapphire";
      variant = "mocha";
    };

    # SDDM QT6 theme with different themes, need to pull from unstable for now
    sddm-astronaut-pixelSakura =
      (
        import inputs.nixpkgs-unstable {system = prev.system;}
      )
      .sddm-astronaut
      .override {
        embeddedTheme = "pixel_sakura";
      };
    sddm-astronaut-blackHole =
      (
        import inputs.nixpkgs-unstable {system = prev.system;}
      )
      .sddm-astronaut
      .override {
        embeddedTheme = "black_hole";
      };

    # Add some fonts to cursor code and pull in from unstable
    code-cursor =
      (
        import inputs.nixpkgs-unstable {
          system = prev.system;
          config.allowUnfree = true;
        }
      ).code-cursor.overrideAttrs (
        oldAttrs: let
          addedFonts = with prev.nerd-fonts; [
            symbols-only
            droid-sans-mono
            fira-code
            sauce-code-pro
            jetbrains-mono
            prev.iosevka
          ];
          addedPackages = with prev; [
            kitty
          ];
        in {
          buildInputs = oldAttrs.buildInputs ++ addedFonts ++ addedPackages;
          runtimeDependencies = oldAttrs.runtimeDependencies ++ addedFonts ++ addedPackages;
        }
      );

    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
