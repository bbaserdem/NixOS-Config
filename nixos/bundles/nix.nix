# Bundling nix related software
{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: {
  # This needs disabling for nix-index flake to work
  programs.command-not-found.enable = false;
  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 60d";
  };
  # Make sure <nixpkgs> path aligns with flake inputs
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  # Nix helper utilities
  environment.systemPackages = with pkgs; [
    nh
    nix-output-monitor
    nvd
    sops
    nix-index
  ];
}
