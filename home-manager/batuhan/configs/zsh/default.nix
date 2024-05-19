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
  # We want FZF for our fuzzy completion menu
  programs.fzf = {
    enable = true;
    package = pkgs.fzf;
    enableZshIntegration = true;
  };
  # Installing Zoxide
  programs.zoxide = {
    enable = true;
    package = pkgs.zoxide;
    enableZshIntegration = true;
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
    historySubstringSearch = {
      enable = true;
      searchDownKey = [ "^[[B" "\${terminfo[kcud1]}" ];
      searchUpKey =   [ "^[[A" "\${terminfo[kcuu1]}" ];
    };
    plugins = [ {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      } {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
      } {
        name = "nix-zsh-completions";
        src = pkgs.nix-zsh-completions;
        file = "share/zsh/plugins/nix/nix-zsh-completions.plugin.zsh";
      } {
        name = "zsh-history-substring-search";
        src = pkgs.zsh-history-substring-search;
        file = "share/zsh-history-substring-search/zsh-history-substring-search.zsh";
      } {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];
    initExtra = ''
      # Prompt theme 
      if [[ -r "${config.xdg.configHome}/powerlevel10k/config.zsh" ]]; then
        prompt off
        source "${config.xdg.configHome}/powerlevel10k/config.zsh"
      fi
      # Recommended by p10k to add this after enabling spaceship theme globally
      (( ! ''${+functions[p10k]} )) || p10k finalize

      # Set editor default keymap to vi (`-v`) or emacs (`-e`)
      bindkey -v

      # Make completion case-insensitive
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      # Get colored ls completions, needs also ls alias
      zstyle ':completion:*' list-colors  "''${(s.:.)LS_COLORS}"
      # Disable native menu in favor of fzf menu, and get directory previews
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
      zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

      # Run arbitrary binaries, needed for mason nvim
      export NIX_LD=$(nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD')
    '';
    shellAliases = {
      ls = "ls --color";
      ll = "ls -l";
    };
    # For powerlevel10k instant prompt
    initExtraFirst = ''
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '';
  };
}
