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
    };
  };

  # Bash options
  programs.bash = {
    # Needed for starship prompt right side
    blesh.enable = true;
  };

  # ZSH
  programs.zsh = {
    enable = true;
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
    enableCompletion = true;
    enableBashCompletion = true;
  };

  # Make root user default shell as zsh
  users.users.root.shell = pkgs.zsh;

  # Let zsh find system-based apps
  environment.pathsToLink = ["/share/zsh"];
}
