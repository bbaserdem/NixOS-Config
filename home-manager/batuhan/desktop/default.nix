# List of desktop integration modules
{
  pkgs,
  lib,
  ...
}: {
  # Some app modules
  imports = [
    # ./gnome.nix
    ./hyprland
    ./keyboard.nix
    ./xdg-paths.nix
  ];

  stylix.targets = {
    gtk = {
      enable = true;
      flatpakSupport.enable = true;
    };
    kde = {
      enable = true;
    };
  };

  # Enable autostarting stuff
  xdg.autostart.enable = true;

  home.packages = with pkgs; [
    libsForQt5.qt5ct
    kdePackages.qt6ct
  ];
}
