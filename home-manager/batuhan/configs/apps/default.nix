# List of userspace applications
{
  pkgs,
  lib,
  ...
}: {
  # Some app modules
  imports = [
    ./browser.nix
    ./btop.nix
    ./discord.nix
    ./editor.nix
    ./image.nix
    ./kitty.nix
    ./newsboat.nix
    ./syncthing.nix
    ./wezterm.nix
    ./zathura.nix
  ];

  home.packages =
    (with pkgs; [
      # Music related
      audacity
      musescore
      picard
      projectm-sdl-cpp
      chromaprint
      # Video related
      vlc
      smplayer
      handbrake
      flowblade
      # Communication
      signal-desktop
      ferdium
      slack
      zoom-us
      remmina
      thunderbird
      # Documents
      calibre
      libreoffice-fresh
      hunspell
      hunspellDicts.en_US
      kdePackages.okular
      obsidian
      zotero
      #texlive.combined.scheme-full
      # Programming gui's
      octaveFull
      spyder
      gitg
      # Utilities
      nemo-with-extensions
      virt-manager
      baobab
      xclicker
      wifi-qr
      dconf2nix
      exiftool
      fzf
      wl-clipboard
      tree
      # hunspellDicts.tr_TR not available
      # Apps to setup
      podgrab
    ])
    ++ (with pkgs.qt5; [
      # QT5 libraries
      qtwayland
    ]);

  # Enable stylix for apps
  stylix.targets = {
    fzf.enable = true;
  };
}
