# Setup btop
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
  programs.btop = {
    enable = true;
    package = pkgs.btop;
    settings = {
      color_theme = "Default";
      proc_sorting = "cpu lazy";
    };
}
