# List of userspace applications
{
  pkgs,
  lib,
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
    freetube
    # Communication
    signal-desktop
    ferdium
    zoom-us
    webcord-vencord
    # Documents
    calibre
    libreoffice-fresh
    hunspell
    hunspellDicts.en_US
    # hunspellDicts.tr_TR not available
    unstable.obsidian
    zotero
    # Programming
    octaveFull
    conda
    # Utilities
    cinnamon.nemo-with-extensions
    virt-manager
    baobab
    # Gaming
    lutris
    heroic
  ];
  # Common services
  services.blueman-applet.enable = lib.mkDefault true;
}
