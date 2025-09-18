# Theming modules
{
  inputs,
  pkgs,
  ...
}: {
  imports =
    (
      if pkgs.stdenv.isDarwin
      then [
        ./starship.nix
      ]
      else if pkgs.stdenv.isLinux
      then [
        inputs.stylix.homeManagerModules.stylix
      ]
      else []
    )
    ++ [
      ./stylix.nix
    ];
}
