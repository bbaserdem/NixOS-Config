# Bundling nix related software
{ pkgs, lib, config, ... }: {
  # This needs disabling for nix-index flake to work
  programs.command-not-found.enable = false;
  environment.systemPackages = with pkgs; [
    unstable.nh
    nix-output-monitor
    nvd
    sops
    nix-index
  ];
}
