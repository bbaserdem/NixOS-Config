# Setup btop
{
  pkgs,
  ...
}: {
  programs.btop = {
    enable = true;
    package = pkgs.btop;
    settings = {
      color_theme = "Default";
      proc_sorting = "cpu lazy";
    };
  };
}
