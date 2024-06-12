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
    chromaprint
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
    remmina
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
    pipx
    # Utilities
    cinnamon.nemo-with-extensions
    virt-manager
    baobab
    # Gaming
    lutris
    heroic
    # Scripts
    user-audio.flac-2-flac
    user-audio.aiff-2-flac
    user-audio.wav-2-flac
    user-audio.flac-2-opus
    user-audio.m4a-2-opus
    user-audio.mp3-2-opus
    user-audio.ogg-2-opus
    user-audio.reencodeLossless
    user-audio.reencodeLossy
  ];
  # Common services
  services.blueman-applet.enable = lib.mkDefault true;
}
