# Bundling nix related software
{ pkgs, lib, config, ... }: {
  environment.systemPackages = with pkgs; [
    unstable.nh
    nix-output-monitor
    nvd
    sops
  ];
}
