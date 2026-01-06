# home-manager/batuhan/desktop/hyprland/shells/default.nix
# Chooses the default shell implementation, this way I can switch easily.
{...}: {
  imports = [
    ./hyprpanel
  ];
}
