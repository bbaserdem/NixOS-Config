# Neovim config
{
  config,
  pkgs,
  ...
}: let
  colors = config.colorScheme.palette;
in {
  programs.neovim = {
    enable = true;
    # Aliases 
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    # Configure nvim as the default editor
    defaultEditor = true;
    # Needed software to run nvim
    extraPackages = with pkgs; [
      # LSP's
      lua-language-server
      # Needed for plugin compilation
      gnumake
      clang
      # Dependencies
      fd            # File finder
      tree-sitter   # CLI tools for tree-sitter
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
}
