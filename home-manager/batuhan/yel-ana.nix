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
  home.file."Media".source = config.lib.file.mkOutOfStoreSymlink "/home/data/Media";
  # Disable autorandr in gnome for now
  services.autorandr.enable = lib.mkOverride 500 false;
}
