# Packageset modifications
# We need inputs to pull unstable when needed, hence pulling the inputs
{inputs, ...}: (final: prev: {
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
})
