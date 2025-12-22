# ./home-manager/batuhan/desktop/hyprland/default.nix
# Hyprland config entry point
{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.dms.homeModules.dankMaterialShell.default
    ./shell.nix
  ];

  # Entry point
  wayland.windowManager.hyprland = {
    enable = true;
    # Needed for uwsm
    systemd.enable = false;
    # We want xwayland
    xwayland.enable = true;
  };
}
