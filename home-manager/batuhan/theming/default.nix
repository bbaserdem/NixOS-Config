# Theming modules
{inputs, ...}: {
  imports = [
    inputs.stylix.homeManagerModules.stylix
    ./stylix.nix
  ];
}
