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

  # Create data symlinks
  home.file."Media".source = config.lib.file.mkOutOfStoreSymlink "/home/data/Media";
  home.file."Shared/Android".source = config.lib.file.mkOutOfStoreSymlink "/home/data/Android";
  home.file."Work".source = config.lib.file.mkOutOfStoreSymlink "/home/data/Work";
  
  # Disable autorandr in gnome for now
  services.autorandr.enable = lib.mkOverride 500 false;

  # Define wallpaper
  myHome.wallpaper.name = "Sunset by the Pier";
}
