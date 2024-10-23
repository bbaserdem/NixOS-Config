# Bundling nix related software
{
  pkgs,
  lib,
  config,
  ...
}: {
  # This needs disabling for nix-index flake to work
  programs.command-not-found.enable = false;
  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    frequency = "weekly";
    options = "-d";
  };
  # Nix helper utilities
  environment.systemPackages = with pkgs; [
    nh
    nix-output-monitor
    nvd
    sops
    nix-index
  ];
}
