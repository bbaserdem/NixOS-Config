# NNN config
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
  colors = config.colorScheme.colors;
in {
  programs.nnn = {
    enable = true;
    package = pkgs.nnn;
    bookmarks = {
      M = "${config.home.homeDirectory}/Media";
      m = "/home/data";
    };
    plugins = {
      src = "${pkgs.nnn}/share/plugins";
    };
  };
}
