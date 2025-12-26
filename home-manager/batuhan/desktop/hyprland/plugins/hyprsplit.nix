# home-manager/batuhan/desktop/hyprland/plugins/hyprsplit.nix
# Hyprsplit: dwm like workspaces
{pkgs, ...}: {
  # Enable hyprland
  wayland.windowManager.hyprland = {
    plugins = [
      pkgs.hyprlandPlugins.hyprsplit
    ];
    settings = {
      plugin.hyprsplit = {
        num_workspaces = 10;
        persistent_workspaces = false;
      };
    };
  };
}
