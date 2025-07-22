{pkgs, ...}: let
  preview = pkgs.callPackage ./preview.nix
  visual = pkgs.callPackage ./visual.nix {};
in (pkgs.symlinkJoin {
  name = "user-vifm";
  paths = [
    preview
    visual
  ];
})
