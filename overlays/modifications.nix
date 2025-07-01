# Packageset modifications
# We need inputs to pull unstable when needed, hence pulling the inputs
{inputs, ...}: (final: prev: {
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
  sddm-astronaut-pixelSakura = prev.sddm-astronaut.override {
    embeddedTheme = "pixel_sakura";
  };
  sddm-astronaut-blackHole = prev.sddm-astronaut .override {
    embeddedTheme = "black_hole";
  };

  # Add some fonts to cursor code
  # Get the latest version
  # Pull from unstable, to use vscode generic builder
  # Hand coded to be linux_x64 for now
  code-cursor_1_1_6 = prev.unstable.code-cursor.overrideAttrs (
    oldAttrs: let
      addedFonts = with prev.nerd-fonts; [
        symbols-only
        droid-sans-mono
        fira-code
        sauce-code-pro
        jetbrains-mono
      ];
      addedPackages = with prev; [
        kitty
        prev.unstable.task-master-ai
      ];
      sources = {
        "x86_64-linux" = prev.fetchurl {
          url = "https://downloads.cursor.com/production/5b19bac7a947f54e4caa3eb7e4c5fbf832389853/linux/x64/Cursor-1.1.6-x86_64.AppImage";
          hash = "sha256-T0vJRs14tTfT2kqnrQWPFXVCIcULPIud1JEfzjqcEIM=";
        };
        "aarch64-linux" = prev.fetchurl {
          url = "https://downloads.cursor.com/production/5b19bac7a947f54e4caa3eb7e4c5fbf832389853/linux/arm64/Cursor-1.1.6-aarch64.AppImage";
          hash = "sha256-T0vJRs14tTfT2kqnrQWPFXVCIcULPIud1JEfzjqcEIM=";
        };
        "x86_64-darwin" = prev.fetchurl {
          url = "https://downloads.cursor.com/production/5b19bac7a947f54e4caa3eb7e4c5fbf832389853/darwin/x64/Cursor-darwin-x64.dmg";
          hash = "sha256-T0vJRs14tTfT2kqnrQWPFXVCIcULPIud1JEfzjqcEIM=";
        };
        "aarch64-darwin" = prev.fetchurl {
          url = "https://downloads.cursor.com/production/5b19bac7a947f54e4caa3eb7e4c5fbf832389853/darwin/arm64/Cursor-darwin-arm64.dmg";
          hash = "sha256-T0vJRs14tTfT2kqnrQWPFXVCIcULPIud1JEfzjqcEIM=";
        };
      };
      source = sources.${prev.hostPlatform.system};
      appVersion = "1.1.6";
    in {
      vscodeVersion = "1.101.2";
      version = appVersion;
      src =
        if prev.hostPlatform.isLinux
        then
          prev.appimageTools.extract {
            pname = oldAttrs.pname;
            version = appVersion;
            src = source;
          }
        else source;
      sourceRoot =
        if prev.hostPlatform.isLinux
        then "${oldAttrs.pname}-${appVersion}-extracted/usr/share/cursor"
        else "Cursor.app";
      buildInputs = oldAttrs.buildInputs ++ addedFonts ++ addedPackages;
      runtimeDependencies = oldAttrs.runtimeDependencies ++ addedFonts ++ addedPackages;
    }
  );
})
