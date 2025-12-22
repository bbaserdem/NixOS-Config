# ./home-manager/batuhan/desktop/hyprland/shell.nix
# The shell to be used
{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.dms.homeModules.dankMaterialShell.default
  ];

  # Dank material shell
  programs.dankMaterialShell = {
    enable = true;
    systemd = {
    };
    enableSystemMonitoring = true;
    enableClipboard = true;
    enableVPN = true;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = false;
  };
}
