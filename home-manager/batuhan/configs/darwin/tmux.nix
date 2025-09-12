# Zellij config
{pkgs, ...}: {
  # Settings
  programs = {
    tmux = {
      enable = true;
      baseIndex = 0;
      clock24 = true;
      mouse = true;
      prefix = "C-g";
      sensibleOnTop = true;
      tmuxinator.enable = true;
      tmuxp.enable = true;
    };
    fzf.tmux = {
      enableShellIntegration = true;
    };
  };
}
