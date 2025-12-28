# home-manager/batuhan/desktop/hyprland/autostart.nix
# Hyprland autostart;
{...}: {
  # Enable programs
  wayland.windowManager.hyprland.settings.exec-once = [
    # Shell
    "uwsm app -- dms run"
    # Password manager
    "uwsm app -- keepassxc"
    # Power alert daemon
    "uwsm app -- poweralertd -s"
  ];
}
