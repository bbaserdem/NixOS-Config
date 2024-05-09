# Configuring wayland
{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  hplug = inputs.hyprland-plugins.packages.${pkgs.system};
in {

  # Hyprland configuration
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    plugins = [
      hplug.hyprbars
      hplug.hyprexpo
      hplug.hyprtrails
    ];
    # Main config for hyprland
    settings = import ./hyprland.nix { colors = config.colorScheme.palette; };
  };

  # Aylur's GTK shell, decoration config
  programs.ags = {
    enable = true;
    extraPackages = with pkgs; [
      gtksourceview
      webkitgtk
      accountsservice
    ];
  };
}
