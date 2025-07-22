# Zellij config
{pkgs, ...}: {
  # Enable theming
  stylix.targets.tmux.enable = true;

  # Settings
  programs.tmux = {
    enable = true;
    baseIndex = 0;
    clock24 = true;
    mouse = true;
    prefix = "C-g";
    sensibleOnTop = true;
    tmuxinator.enable = true;
    tmuxp.enable = true;
    enableShellIntegration = true;
  };
}
