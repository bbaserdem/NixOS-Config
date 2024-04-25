# Setup btop
{
  pkgs,
  lib,
  ...
}: {
  programs.btop = {
    enable = lib.mkOptionDefault true;
    package = pkgs.btop;
    settings = {
      color_theme = "Default";
      proc_sorting = "cpu lazy";
    };
  };
}
