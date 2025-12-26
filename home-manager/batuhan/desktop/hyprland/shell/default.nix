# home-manager/batuhan/desktop/hyprland/shell/default.nix
# The shell config, using dank material shell
{
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.dms.homeModules.dankMaterialShell.default
  ];

  programs.dankMaterialShell = {
    enable = true;
    # We are on uwsm, let hyprland launch us
    systemd = {
      enable = false;
      restartIfChanged = true;
    };
    # Features
    enableSystemMonitoring = true;
    enableClipboard = true;
    enableVPN = true;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = false;
  };

  # Enable us to launch on start with uwsm
  wayland.windowManager.hyprland.settings.exec-once = [
    "uwsm app -- dms run"
  ];
}
