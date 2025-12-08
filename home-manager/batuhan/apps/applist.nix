# List of userspace applications
{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    # Communication
    signal-desktop # Messaging
    ferdium # Comms aggregator
    zoom-us # Video conferancing
    # Documents
    calibre
    libreoffice-fresh
    hunspell
    hunspellDicts.en_US
    kdePackages.okular
    zotero
    obsidian
    # Programming
    octaveFull
    gitg
    # Gaming
    nexusmods-app-unfree
    # Utilities
    kdePackages.dolphin # File browser
    virt-manager # Virtual machine manager
    baobab # Disk usage analyzer
    wl-clipboard # Clipboard manager
    # Small tools & libraries
    wifi-qr # QR code for wifi
    qt5.qtwayland # Wayland support for old qt apps
  ];
}
