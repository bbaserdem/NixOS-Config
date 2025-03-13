# Configuring wayland
{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  # Stylix integration
  stylix.targets = {
    hyprland = {
      enable = true;
      # This is in stylix unstable
      #hyprpaper.enable = true;
    };
    hyprlock.enable = true;
    hyprpaper.enable = true;
  };

  # Enable hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    enableXdgAutostart = true;
    # importantPrefixes = [];
    # settings = [];
    # extraConfig = "";
    # Plugins
    # plugins = [];
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
    gnome-control-center # Control center, stealing from gnome
    playerctl # mpdris controller tool
    brightnessctl # lights controller
    pulseaudioFull # Volume adjustments
  ];
}
