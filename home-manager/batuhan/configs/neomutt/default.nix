# Neomutt config
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
  programs.neomutt = {
    enable = true;
  };
}
