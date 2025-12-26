# home-manager/batuhan/desktop/hyprland/monitors.nix
# Hyprland dynamic monitor configuration
{
  config,
  inputs,
  arch,
  ...
}: let
  confFile = "${config.xdg.configHome}";
in {
  # Enable hyprland
  wayland.windowManager.hyprland.settings.source = [
    #"${confFile}"
  ];

  # Install the package
  home.packages = [
    inputs.hyprdynamicmonitors.packages.${arch}.default
  ];
}
