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
  # Create the media symlink
  home.file."Media".source = lib.file.mkOutOfStoreSymlink "/home/data/Media";
}
