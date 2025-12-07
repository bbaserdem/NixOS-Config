# List of desktop integration modules
{
  pkgs,
  lib,
  ...
}: {
  # Some app modules
  imports = [
    ./gnome.nix
    ./keyboard.nix
    ./xdg-paths.nix
  ];

  stylix.targets = {
    gtk = {
      enable = true;
      flatpakSupport.enable = true;
    };
    qt = {
      enable = true;
    };
  };
}
