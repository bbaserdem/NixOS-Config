# ZSH config 
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  myLib,
  rootPath,
  ...
}: {
  # We will put the config file for powerlevel10k in it's own directory
  xdg.configFile."powerlevel10k/config.zsh" = {
    source = ./powerlevel10k_config.zsh;
    executable = false;
  };
  # Setup zsh, only plugin i need is powerlevel10k honestly
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    dotDir = ".config/zsh";
    # History
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreAllDups = true;
      path = "${config.xdg.cacheHome}/zsh/history";
      share = true;
    };
    plugins = [
      { name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
    # Prompt theme 
    initExtra = "source ${config.xdg.configHome}/powerlevel10k/config.zsh";
    ''
      if [[ -r "''${XDG_CONFIG_HOME}/powerlevel10k/config.zsh" ]]; then
        source "''${XDG_CONFIG_HOME}/powerlevel10k/config.zsh"
      fi
    ''
    # For powerlevel10k instant prompt
    initExtraFirst = ''
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '';
  };
}
