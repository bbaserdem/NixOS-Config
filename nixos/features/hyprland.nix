# Hyprland userspace patching

{
  lib,
  config,
  inputs,
  outputs,
  myLib,
  pkgs,
  rootPath,
  ... 
}: {
  # Enables hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
}
