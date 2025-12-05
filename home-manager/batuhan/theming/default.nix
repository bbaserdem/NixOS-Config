# Theming modules
{
  inputs,
  pkgs,
  system,
  ...
}: {
  imports = [
    inputs.stylix.homeModules.stylix
    ./stylix.nix
  ];
}
