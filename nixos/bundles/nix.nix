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
  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 60d";
    };
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
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
