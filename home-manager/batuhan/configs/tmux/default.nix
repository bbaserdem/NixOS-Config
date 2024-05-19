# TMUX config
{pkgs, ...}: {
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
