# List of userspace applications
{
  pkgs,
  lib,
  config,
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
    digikam
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
    kdePackages.okular
    # hunspellDicts.tr_TR not available
    obsidian
    zotero
    #texlive.combined.scheme-full
    # Programming
    octaveFull
    conda
    pipx
    # Utilities
    nemo-with-extensions
    virt-manager
    baobab
    xclicker
    wifi-qr
    dconf2nix
    # Gaming
    lutris
    heroic
    # Scripts
    user-audio-flac-2-flac
    user-audio-aiff-2-flac
    user-audio-wav-2-flac
    user-audio-flac-2-opus
    user-audio-m4a-2-opus
    user-audio-mp3-2-opus
    user-audio-ogg-2-opus
    user-audio-reencodeLossless
    user-audio-reencodeLossy
    user-audio-syncDAC
    user-audio-playlist-2-android
    # Apps to setup
    podgrab
    #paperless-ngx
  ];
  # Common services
  services.blueman-applet.enable = lib.mkDefault true;
  # Configuration options
  # xdg.configFile."Ferdium".source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.cacheHome}/Ferdium";
}
