# home-manager/batuhan/desktop/hyprland/default.nix
# Hyprland entry point
{config, ...}: {
  imports = [
    ./settings.nix
    ./keybinds.nix
    ./monitors
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
}
