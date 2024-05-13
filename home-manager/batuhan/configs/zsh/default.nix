# ZSH config 
{
  config,
  pkgs,
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
    plugins = [ {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      } {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
        file = "share/zsh-completions/zsh-completions";
      } {
        name = "nix-zsh-completions";
        src = pkgs.nix-zsh-completions;
        file = "share/zsh/plugins/nix/nix-zsh-completions.plugin.nix";
      } {
        name = "zsh-history-substring-search";
        src = pkgs.zsh-history-substring-search;
        file = "share/zsh-history-substring-search/zsh-history-substring-search.zsh";
      }
    ];
    initExtra = ''
      # Prompt theme 
      if [[ -r "${config.xdg.configHome}/powerlevel10k/config.zsh" ]]; then
        prompt off
        source "${config.xdg.configHome}/powerlevel10k/config.zsh"
      fi
      # Set editor default keymap to vi (`-v`) or emacs (`-e`)
      bindkey -v
      # Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
      zmodload -F zsh/terminfo +p:terminfo
      if [[ -n ''${terminfo[kcuu1]} && -n ''${terminfo[kcud1]} ]]; then
        bindkey ''${terminfo[kcuu1]} history-substring-search-up
        bindkey ''${terminfo[kcud1]} history-substring-search-down
      fi
      # Recommended by p10k to add this after enabling spaceship theme globally
      (( ! ''${+functions[p10k]} )) || p10k finalize
      # Run arbitrary binaries, needed for mason nvim
      export NIX_LD=$(nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD')
    '';
    # For powerlevel10k instant prompt
    initExtraFirst = ''
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '';
  };
}
