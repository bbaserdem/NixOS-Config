# Theming modules
{
  inputs,
  pkgs,
  system,
  ...
}: {
  imports = [
    inputs.stylix.homeManagerModules.stylix
    ./stylix.nix
  ];
}
