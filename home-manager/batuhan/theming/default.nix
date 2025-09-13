# Theming modules
{
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.stylix.homeManagerModules.stylix
    ./stylix.nix
  ];
}
