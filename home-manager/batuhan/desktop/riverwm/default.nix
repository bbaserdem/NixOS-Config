# ./home-manager/batuhan/desktop/riverwm/default.nix
# River config entry point
{
  pkgs,
  lib,
  ...
}: {
  # Entry point
  wayland.windowManager.river = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
    # Init file contents
    extraConfig = builtins.readFile ./init;
  };
}
