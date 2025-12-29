# home-manager/batuhan/desktop/hyprland/autostart.nix
# Hyprland autostart;
{...}: {
  # Enable programs
  wayland.windowManager.hyprland.settings.exec-once = [
    # Shell - as service for stability
    "uwsm app -t service -- dms run"
    # Power alert daemon - background daemon
    "uwsm app -t service -- poweralertd -s"
  ];
}
