# Setup btop
{
  pkgs,
  lib,
  ...
}: {
  # Enable color theme
  stylix.targets.btop.enable = true;

  # Configure btop
  programs.btop = {
    enable = lib.mkDefault true;
    package = pkgs.btop;
    settings = {
      #color_theme = "Default";
      proc_sorting = "cpu lazy";
    };
  };
}
