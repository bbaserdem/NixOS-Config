# ./home-manager/batuhan/desktop/hyprland/default.nix
# Hyprland config entry point
{pkgs, ...}: {
  imports = [
    ./shell.nix
    ./settings.nix
    ./keybinds.nix
    ./idle.nix
    # ./kanshi.nix
  ];

  # Styling
  stylix.targets.hyprland = {
    enable = true;
    colors.enable = true;
    hyprpaper.enable = true;
    image.enable = true;
  };

  # Generic settings
  wayland.windowManager.hyprland = {
    enable = true;
    # Use OS level packages
    package = null;
    portalPackage = null;
    # Needed for uwsm
    systemd.enable = false;
    # We want xwayland
    xwayland.enable = true;
  };
  services.hyprpaper = {
    enable = true;
  };

  # Apps
  home.packages = with pkgs; [
    brightnessctl
    hyprshot
    hyprpicker
  ];
}
