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
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      #outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  # Common personal module toggles
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
