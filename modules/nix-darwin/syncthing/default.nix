# Add your reusable nix-darwin modules to this directory,
{
  inputs,
  outputs,
  config,
  lib,
  options,
  pkgs,
  ...
}: {
  # Separate into functions
  imports = [
    ./definitions.nix
  ];
}
