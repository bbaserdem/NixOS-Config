# Neovim config
{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;
    package = pkgs.unstable.neovim-unwrapped;
    # Aliases
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    # Configure nvim as the default editor
    defaultEditor = true;
    # Needed software to run nvim
    extraPackages = with pkgs; [
      # LSP's, grab whatever system lsp's we can get
      lua-language-server
      clang-tools
      nixd
      nodePackages.typescript-language-server
      # Needed for plugin compilation
      gnumake
      clang
      nodejs
      # Dependencies
      python311Packages.pynvim # Python communicator
      fd # File finder
      tree-sitter # CLI tools for tree-sitter
      glow # Markdown typesetting
      pplatex # Latex log parsing
      neovim-remote # Clientserver for vimtex to run latexmk
      ripgrep # For filesearch capabilities in Obsidian
      xclip # Copy-paste in X
      wl-clipboard # Copy-paste in wayland
      libnotify # Send notifications to DBus for pomodoro timer
    ];
  };
  # Send in the needed config files
  xdg.configFile."nvim" = {
    enable = true;
    source = ./nvim;
    recursive = true;
  };
  # Command to test nvim setup without changing home-manager config
  programs.zsh.shellAliases.nvim-test = "nvim -u \"\${FLAKE}/home-manager/batuhan/configs/neovim/nvim/init.lua\"";
  # Fetch language files
  xdg.dataFile = {
    "nvim/site/spell/tr.utf-8.spl" = {
      source = inputs.vimspell-tr;
    };
    "nvim/site/spell/en.utf-8.spl" = {
      source = inputs.vimspell-en;
    };
  };

  # Transitioning to nixCats
  home.packages = [
    pkgs.nixCats-full
  ];
}
