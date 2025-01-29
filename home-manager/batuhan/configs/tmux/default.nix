# TMUX config
{pkgs, ...}: {

  # Enable theming
  stylix.targets.tmux.enable = true;

  # Settings
  programs.tmux = {
    enable = true;
    package = pkgs.tmux;
    clock24 = true;
    keyMode = "vi";
    mouse = true;
    newSession = true;
    tmuxp.enable = true;
  };
}
