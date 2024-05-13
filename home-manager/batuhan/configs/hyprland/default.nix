# Configuring wayland
{
  inputs,
  pkgs,
  config,
  ...
}: let
  plugpkgs = inputs.hyprland-plugins.packages.${pkgs.system};
in {
  imports = [
    ./hyprpaper.nix
  ];

  # Hyprland configuration
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    plugins = [
      #plugpkgs.hyprbars
      #plugpkgs.hyprexpo
      #plugpkgs.hyprtrails
    ];
    # Main config for hyprland
    settings = import ./hyprland.nix {
      colors = config.colorScheme.palette;
      xkbConfig = config.home.keyboard;
    };
  };

  # Aylur's GTK shell, decoration config
  # AGS can;
  # - Do notifications   
  programs.ags = {
    enable = true;
    extraPackages = with pkgs; [
      gtksourceview
      webkitgtk
      accountsservice
    ];
  };

  # Tools specific for this desktop
  home.packages = with pkgs; [
    libsForQt5.polkit-kde-agent   # Privilege escalator prompt
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
    swww                          # Smooth wallpaper switching daemon
    nwg-drawer                    # Gnome-like app drawer
    hyprshade                     # Screen blue-light filter
    kanshi                        # Dynamic display manager
    wlogout                       # Simple logout gui
    cliphist                      # Clipboard manager
    hyprpicker                    # Color picker
  ];
}
