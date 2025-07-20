# Module that configures shells system wide
{
  pkgs,
  lib,
  ...
}: {
  # Shell prompt
  programs.starship = {
    enable = true;
    interactiveOnly = true;
    presets = [
      #"jetpack"
      "nerd-font-symbols"
    ];
    settings = {
      follow_symlinks = true;
      format = "$shell$all";
      shell = {
        disabled = false;
        bash_indicator = " ";
        zsh_indicator = "󱉸 ";
        fish_indicator = "󰈺 ";
        powershell_indicator = " ";
        ion_indicator = " ";
        style = "cyan";
      };
    };
  };

  # Bash options
  programs.bash = {
    # Undistract me stuff
    undistractMe = {
      enable = true;
      timeout = 20;
      playSound = true;
    };
    # Bash settings
    vteIntegration = true;
    interactiveShellInit = ''
      # Fix colors in bash
      case $${TERM} in
        xterm-color|*-256color|xterm-kitty) color_prompt=yes;;
      esac
    '';
  };

  # ZSH
  programs.zsh = {
    enable = true;
    vteIntegration = true;
    syntaxHighlighting = {
      enable = true;
      highlighters = [
        "main"
        "brackets"
        "root"
      ];
      styles = {
        "root" = "fg=red,bold";
      };
    };
    autosuggestions = {
      enable = true;
      strategy = [
        "completion"
        "match_prev_cmd"
      ];
    };
    enableLsColors = true;
    enableCompletion = true;
    enableBashCompletion = true;
  };

  # Make root user default shell as zsh
  users.users.root.shell = pkgs.zsh;

  # Let zsh find system-based apps
  environment.pathsToLink = ["/share/zsh"];
}
