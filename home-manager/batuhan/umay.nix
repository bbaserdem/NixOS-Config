# batuhan@umay home configuration

{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  myLib,
  rootPath,
  ...
}: {
  # Just default to regular now 
  imports = [
    ./default.nix
  ];
}
