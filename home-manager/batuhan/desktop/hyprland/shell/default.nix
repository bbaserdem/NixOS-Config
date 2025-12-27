# home-manager/batuhan/desktop/hyprland/shell/default.nix
# The shell config, using dank material shell
{
  inputs,
  pkgs,
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

  home.packages = with pkgs; [
    papirus-icon-theme
  ];
}
