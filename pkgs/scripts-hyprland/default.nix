{pkgs, ...}: let
  fuzzel-window = pkgs.callPackage ./fuzzel-window.nix {};
in (pkgs.symlinkJoin {
  name = "user-hyprland";
  paths = [
    fuzzel-window
  ];
})
