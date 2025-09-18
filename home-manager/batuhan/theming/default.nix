# Theming modules
{
  inputs,
  pkgs,
  ...
}: {
  imports =
    [
      ./stylix.nix
    ]
    ++ (
      if pkgs.stdenv.hostPlatform.isDarwin
      then [
        ./starship.nix
      ]
      else if pkgs.stdenv.hostPlatform.isLinux
      then [
        inputs.stylix.homeManagerModules.stylix
      ]
      else []
    );
}
