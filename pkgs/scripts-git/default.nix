# My git scripts
{pkgs, ...}: let
  bonzai = pkgs.callPackage ./bonzai.nix
  bloom = pkgs.callPackage ./bloom.nix {};
in (pkgs.symlinkJoin {
  name = "user-git";
  paths = [
    bonzai
    bloom
  ];
})
