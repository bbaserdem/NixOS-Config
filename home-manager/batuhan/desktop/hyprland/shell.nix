# home-manager/batuhan/desktop/hyprland/shell.nix
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
    # Core features
    enableSystemMonitoring = false; # System monitoring widgets (dgop)
    enableClipboard = false; # Clipboard history manager
    enableVPN = false; # VPN management widget
    enableDynamicTheming = false; # Wallpaper-based theming (matugen)
    enableAudioWavelength = false; # Audio visualizer (cava)
    enableCalendarEvents = false; # Calendar integration (khal)
  };
}
