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
      lua-language-server
      gnumake
      clang
    ];
  };
  # Send in the needed config files
  xdg.configFile."nvim" = {
    enable = true;
    source = ./nvim;
    recursive = true;
  };
  programs.zsh.shellAliases.nvim-test = "nvim -u \"\${FLAKE}/home-manager/batuhan/configs/neovim/nvim/init.lua\"";
}
