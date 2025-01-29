# batuhan@umay home configuration
{
  lib,
  config,
  pkgs,
  ...
}: {
  # Just default to regular now
  imports = [
    ./default.nix
  ];
  # Create data symlinks
  home.file."Media".source = config.lib.file.mkOutOfStoreSymlink "/home/data/Media";
  home.file."Shared/Android".source = config.lib.file.mkOutOfStoreSymlink "/home/work/Android";
  home.file."Work".source = config.lib.file.mkOutOfStoreSymlink "/home/work/Work";
  # Disable autorandr in gnome for now
  services.autorandr.enable = lib.mkOverride 500 false;

  # Define wallpaper
  myHome.wallpaper.name = "Snow-Capped Mountain";
}
