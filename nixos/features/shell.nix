# Module that enables a default zsh shell
{
  pkgs,
  lib,
  ...
}: let
  starship = pkgs.starship;
  starship-bin = "${starship}/bin/starship";
in {
  # Shell prompt
  programs.starship = {
    enable = true;
    interactiveOnly = true;
    package = starship;
    presets = [
      "nerd-font-symbols"
    ];
    settings = {
      follow_symlinks = true;
    };
  };

  # Bash options
  programs.bash = {
    # Needed for starship prompt
    blesh.enable = true;
    promptInit = ''
      # Starship prompt default
      eval "$(${starship-bin} init bash)"
    '';
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
    promptInit = ''
      # Note that to manually override this in ~/.zshrc you should run `prompt off`
      # before setting your PS1 and etc. Otherwise this will likely to interact with
      # your ~/.zshrc configuration in unexpected ways as the default prompt sets
      # a lot of different prompt variables.
      #
      # Old prompt
      # autoload -U promptinit && promptinit && prompt spaceship && setopt prompt_sp
      #
      # New prompt
      eval "$(${starship-bin} init zsh)"
    '';
  };

  # Make root user default shell as zsh
  users.users.root.shell = pkgs.zsh;

  # Let zsh find system-based apps
  environment.pathsToLink = ["/share/zsh"];
}
