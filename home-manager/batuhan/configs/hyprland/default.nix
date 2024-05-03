# Hyprland setup
{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    waybar
  ];
}
