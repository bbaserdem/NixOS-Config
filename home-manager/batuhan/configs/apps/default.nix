# List of userspace applications
{
  pkgs,
  lib,
  ...
}: {
  # Some app modules
  imports = [
    ./btop.nix
    ./discord.nix
    ./editor.nix
    ./firefox.nix
    ./kitty.nix
    ./newsboat.nix
    ./wezterm.nix
  ];

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
    projectm-sdl-cpp
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
    awscli2
    nemo-with-extensions
    virt-manager
    baobab
    xclicker
    wifi-qr
    dconf2nix
    exiftool
    fzf
    wl-clipboard
    # Scripts
    user-audio
    # Apps to setup
    podgrab
    uv
  ];

  # Enable stylix for apps
  stylix.targets = {
    fzf.enable = true;
  };

  # Common services
  services.blueman-applet.enable = lib.mkDefault true;
}
