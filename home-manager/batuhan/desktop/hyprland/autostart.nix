# home-manager/batuhan/desktop/hyprland/autostart.nix
# Hyprland autostart;
{lib, ...}: {
  # Enable programs
  wayland.windowManager.hyprland.settings.exec-once = [
    # Inhibit power button handling by logind so we can show a login script
    "systemd-inhibit --what=handle-power-key --who=hyprland --why='Handled by Hyprland keybinds' --mode=block sleep infinity"
  ];

  # Idle daemon
  services.hypridle = {
    enable = true;
    systemdTarget = "wayland-session@Hyprland.target";
  };

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

  # Hyprdynamicmonitors, no settings here; look at monitors for the settings
  home.hyprdynamicmonitors = {
    enable = true;
    systemdTarget = "wayland-session@Hyprland.target";
  };
}
