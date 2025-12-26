# home-manager/batuhan/desktop/hyprland/autostart.nix
# Programs to autostart
{...}: {
  wayland.windowManager.hyprland.settings.exec-once = [
    # "uwsm app -- dms run"
    # "uwsm app -- hyprdynamicmonitors run --enable-lid-events"
  ];
}
