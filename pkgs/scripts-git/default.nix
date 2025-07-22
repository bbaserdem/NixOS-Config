# git-scripts: Collection of user git scripts
{pkgs, ...}: let
  arbor = pkgs.callPackage ./arbor.nix {};
  bonzai = pkgs.callPackage ./bonzai.nix {};
  ikebana = pkgs.callPackage ./ikebana.nix {};
  sprout = pkgs.callPackage ./sprout.nix {};
in (pkgs.symlinkJoin {
  name = "user-git";
  paths = [
    arbor
    bonzai
    ikebana
    sprout
  ];
})
