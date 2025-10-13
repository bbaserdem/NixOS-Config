# Zellij config
{pkgs, ...}: {
  # Enable theming
  stylix.targets.tmux.enable = true;

  # Settings
  programs = {
    tmux = {
      enable = true;
      baseIndex = 0;
      clock24 = true;
      mouse = true;
      prefix = "C-a";
      sensibleOnTop = true;
      tmuxinator.enable = true;
      tmuxp.enable = true;
      extraConfig = ''
        # Split panes
        bind | split-window -h
        bind - split-window -v
        unbind '"'
        unbind %

        # Change panes with Alt-arrow
        bind -n M-Left  select-pane -L
        bind -n M-Right select-pane -R
        bind -n M-Up    select-pane -U
        bind -n M-Down  select-pane -D

        # Turn off bell
        set -g visual-activity off
        set -g visual-bell off
        set -g visual-silence off
        set -g bell-action none
        setw -g monitor-activity off
      '';
    };
    fzf.tmux = {
      enableShellIntegration = true;
    };
  };
}
