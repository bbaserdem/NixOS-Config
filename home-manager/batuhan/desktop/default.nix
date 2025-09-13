# List of desktop integration modules
{
  pkgs,
  lib,
  ...
}: {
  # Some app modules
  imports = [
    ./keyboard.nix
    ./xdg-paths.nix
  ];
}
