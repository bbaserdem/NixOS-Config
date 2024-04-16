# Common configuration options for all the hosts
{
  inputs,
  outputs,
  myLib,
  lib,
  config,
  pkgs,
  system,
  rootPath,
  ...
}: {
  # Nixpkgs options
  nixpkgs = {
    overlays = [
      #outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
  };

  # Personal module toggles
  myNixOS = {
    # Bundles
    bundles = {
      archives.enable = true;
      utils.enable = true;
      tools.enable = true;
      filesystems.enable = true;
    };
    # Services
    services = {
      satisfactory.enable = false;
    };
  };
}
