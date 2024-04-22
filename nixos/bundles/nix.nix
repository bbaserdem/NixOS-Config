# Bundling nix related software
{ pkgs, lib, config, ... }: {
  environment.systemPackages = with pkgs; [
    nh
    nix-output-monitor
    nvd
  ];
}
