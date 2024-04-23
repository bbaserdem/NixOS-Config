# Neovim config
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  myLib,
  rootPath,
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
    ];
  };
  # Send in the needed config files
  xdg.configFile."nvim" = {
    enable = true;
    source = ./nvim;
    recursive = true;
  };
}
