# Configuring aylur's gtk shell
{
  inputs,
  pkgs,
  lib,
  ...
}: {
  program.ags = {
    enable = true;
    configDir = ../ags;
    extraPackages = with pkgs; [
      gtksourceview
      webkitgtk
      accountsservice
    ];
  };
}
