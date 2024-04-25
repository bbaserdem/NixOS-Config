# Neomutt config
{
  config,
  pkgs,
  ...
}: let
  colors = config.colorScheme.palette;
in {
  programs.neomutt = {
    enable = true;
  };
}
