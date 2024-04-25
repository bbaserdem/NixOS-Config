# Setup btop
{
  pkgs,
  lib,
  ...
}: {
  programs.btop = {
    enable = lib.mkDefault true;
    package = pkgs.btop;
    settings = {
      color_theme = "Default";
      proc_sorting = "cpu lazy";
    };
  };
}
