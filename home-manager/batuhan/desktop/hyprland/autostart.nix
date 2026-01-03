# home-manager/batuhan/desktop/hyprland/autostart.nix
# Hyprland autostart;
{
  config,
  lib,
  ...
}: {
  # Enable programs
  wayland.windowManager.hyprland.settings.exec-once = [
    # Shell - as service for stability
    "uwsm app -t service -- ${config.programs.hyprpanel.package}/bin/hyprpanel"
    # Power alert daemon - background daemon
    "uwsm app -t service -- ${config.services.poweralertd.package}/bin/poweralertd -s"
    # Inhibit power button handling by logind so we can show a login script
    "systemd-inhibit --what=handle-power-key --who=hyprland --why='Handled by Hyprland keybinds' --mode=block sleep infinity"

    # We don't need to launch hypridle through here, the systemd unit has target
    # Hyprdynamicmonitors is the same, it exposes a systemdTarget config setting
    # We do need to override hyprpaper
  ];

  # Hyprpaper automatically enables systemd unit
  # The target needs overwriting to isolate to hyprland
  stylix.targets.hyprpaper = {
    enable = true;
    image.enable = true;
  };
  services.hyprpaper = {
    enable = true;
  };
  systemd.user.services.hyprpaper = {
    Install.WantedBy = lib.mkForce ["wayland-session@Hyprland.target"];
    Unit = {
      After = lib.mkForce ["wayland-session@Hyprland.target"];
      PartOf = lib.mkForce ["wayland-session@Hyprland.target"];
    };
  };
}
