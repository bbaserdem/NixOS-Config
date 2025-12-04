# ZSH config
{
  config,
  pkgs,
  lib,
  ...
}: let
  zshConfigEarlyInit = lib.mkBefore ''
    #--START--ZSH Config before everything
    #---END---ZSH Config before everything

  '';
  zshConfigBeforeCompinit = lib.mkOrder 550 ''
    #--START--ZSH Config before compinit
    #---END---ZSH Config before compinit

  '';
  zshConfig = lib.mkOrder 1000 ''
    #--START--ZSH Config
    # Function to get nix program location
    nix-getPackage () {
      this_link="$(which "''${1}")"
      readlink "''${this_link}"
    }

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

    # Run arbitrary binaries, needed for mason in neovim (not needed with nixCats)
    # export NIX_LD=$(nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD')
    #---END---ZSH Config

  '';
  zshConfigAfter = lib.mkOrder 1500 ''
    #--START--ZSH Config after everything else
    # Load our exported secrets, this has to be here
    export GH_TOKEN="$(cat ${config.sops.secrets.gh-auth.path})"
    export GITHUB_TOKEN="''${GH_TOKEN}"
    #---END---ZSH Config after everything else
  '';
in {
  # Integrations
  home.shell.enableBashIntegration = true;
  programs.fzf.enableZshIntegration = true;
  programs.direnv.enableZshIntegration = true;
  programs.kitty.shellIntegration.enableZshIntegration = true;
  programs.nix-index.enableZshIntegration = true;
  programs.starship.enableZshIntegration = true;
  programs.yazi.enableZshIntegration = true;
  programs.zoxide.enableZshIntegration = true;

  # Setup zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    # History
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreAllDups = true;
      path = "${config.home.homeDirectory}/.cache/zsh/history";
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
    initContent = lib.mkMerge [
      zshConfigEarlyInit
      zshConfigBeforeCompinit
      zshConfig
      zshConfigAfter
    ];
  };
}
