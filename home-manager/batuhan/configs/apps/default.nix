# List of userspace applications
{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # Image editing
    darktable
    inkscape
    gimp-with-plugins
    vimiv-qt
    qimgv
    imagemagick
    blender
    # Music related
    audacity
    musescore
    picard
    cantata
    projectm
    # Video related
    vlc
    smplayer
    droidcam
    handbrake
    flowblade
    # Communication
    signal-desktop
    ferdium
    zoom-us
    # Documents
    calibre
    libreoffice-fresh
    hunspell
    hunspellDicts.en_US
    # hunspellDicts.tr_TR not available
    obsidian
    zotero
    # Programming
    octaveFull
    # Utilities
    cinnamon.nemo-with-extensions
    virt-manager
    baobab
  ];
  # Common services
  services.blueman-applet.enable = true;
}