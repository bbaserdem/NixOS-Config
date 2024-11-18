# ZSH config
{
  config,
  pkgs,
  ...
}: {
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
  # Shell prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };
  # Setup zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
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
      searchDownKey = ["^[[B" "\${terminfo[kcud1]}"];
      searchUpKey = ["^[[A" "\${terminfo[kcuu1]}"];
    };
    plugins = [
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
      }
      {
        name = "nix-zsh-completions";
        src = pkgs.nix-zsh-completions;
        file = "share/zsh/plugins/nix/nix-zsh-completions.plugin.zsh";
      }
      {
        name = "zsh-history-substring-search";
        src = pkgs.zsh-history-substring-search;
        file = "share/zsh-history-substring-search/zsh-history-substring-search.zsh";
      }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];
    initExtra = ''
      # Set editor default keymap to vi (`-v`) or emacs (`-e`)
      bindkey -e

      # Make completion case-insensitive
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      # Get colored ls completions, needs also ls alias
      zstyle ':completion:*' list-colors  "''${(s.:.)LS_COLORS}"
      # Disable native menu in favor of fzf menu, and get directory previews
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
      zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
    '';
    shellAliases = {
      ls = "ls --color";
      ll = "ls -l";
    };
  };
}
