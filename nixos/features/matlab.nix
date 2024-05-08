# Module that configures grub

{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  # Import the nix-matlab overlay
  nixpkgs.overlays = [
    inputs.nix-matlab.overlay
  ];
  # Import the matlab package
  environment.systemPackages = with pkgs; [
    matlab
  ];
}
