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
    ./hyprland.nix
    ./keybinds.nix
    # ./ags.nix         # Notifications, bars and widgets
    # ./cliphist.nix    # Clipboard manager
    # ./ags.nix         # Notifications, bars and widgets
    # ./hyprshade.nix   # Screen dimmer
    # ./kanshi.nix      # Auto layout for hotplugging monitors
    # ./nwg-drawer.nix  # App launcher/drawer
    # ./swww.nix        # Wallpaper manager
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
  };

  # Aylur's GTK shell, decoration config
  # AGS can;
  # - Do notifications
  programs.ags = {
    enable = true;
    configDir = ./ags;
    extraPackages = with pkgs; [
      gtksourceview
      webkitgtk
      accountsservice
    ];
  };

  # Tools specific for this desktop
  home.packages = with pkgs; [
    libsForQt5.polkit-kde-agent # Privilege escalator prompt
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
    swww # Smooth wallpaper switching daemon
    nwg-drawer # Gnome-like app drawer
    hyprshade # Screen blue-light filter
    kanshi # Dynamic display manager
    cliphist # Clipboard manager
    wl-clipboard
    hyprpicker # Color picker
    gnome.gnome-control-center # Control center, stealing from gnome
    playerctl # mpdris controller tool
    brightnessctl # lights controller
    pulseaudioFull # Volume adjustments
  ];

  # Add gnome settings since it's nice
  xdg.desktopEntries."org.gnome.Settings" = {
    name = "Settings";
    comment = "Gnome Control Center";
    icon = "org.gnome.Settings";
    exec = "env XDG_CURRENT_DESKTOP=gnome ${pkgs.gnome.gnome-control-center}/bin/gnome-control-center";
    categories = ["X-Preferences"];
    terminal = false;
  };
}
