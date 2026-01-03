# home-manager/batuhan/desktop/hyprland/shell/default.nix
# The shell config, using dank material shell
{...}: {
  programs.hyprpanel = {
    # Enable hyprpanel
    enable = true;
    # We are going to launch ourselves with uwsm
    systemd.enable = false;
    # Settings
    # settings = {};
  };
}
