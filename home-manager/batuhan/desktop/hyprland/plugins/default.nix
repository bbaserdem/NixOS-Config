# home-manager/batuhan/desktop/hyprland/plugins/default.nix
# Plugin entry point
{...}: {
  imports = [
    ./hyprsplit.nix
  ];
}
