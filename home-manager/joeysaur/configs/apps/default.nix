# List of userspace applications
{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs; [
    # Browser
    chromium
    # Music related
    spotify
    cantata
    # Video related
    vlc
    droidcam
    # Communication
    signal-desktop
    ferdium
    zoom-us
    webcord-vencord
    # Documents
    libreoffice-fresh
    hunspell
    hunspellDicts.en_US
    kdePackages.okular
    texstudio
    # Programming
    conda
    pipx
    # Utilities
    cinnamon.nemo-with-extensions
    wifi-qr
    # Gaming
    lutris
    heroic
    # Apps to setup
    podgrab
    #paperless-ngx
  ];
  # Common services
  services.blueman-applet.enable = lib.mkDefault true;
}
