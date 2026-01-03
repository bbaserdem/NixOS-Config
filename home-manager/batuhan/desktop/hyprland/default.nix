# home-manager/batuhan/desktop/hyprland/default.nix
# Hyprland entry point
{
  config,
  pkgs,
  host,
  inputs,
  ...
}: {
  imports = [
    # External
    inputs.hyprdynamicmonitors.homeManagerModules.default
    # Internal
    ./monitors
    ./keybinds.nix
    ./autostart.nix
    ./idle.nix
    ./launcher.nix
    ./lock.nix
    ./plugins.nix
    ./settings.nix
    ./shell.nix
  ];

  # Styling
  stylix.targets.hyprland = {
    colors.enable = true;
    enable = true;
  };

  # Systemd fix for uwsm
  xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

  # Enable hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.enable = false;
  };

  # Environment packages
  home.packages = with pkgs; [
    playerctl
    brightnessctl
    poweralertd
  ];

  # Utilities
  programs = {
    # Screenshot utility
    hyprshot = {
      enable = true;
      saveLocation = "${config.xdg.userDirs.pictures}/Screenshots/${host}/";
    };
  };
}
