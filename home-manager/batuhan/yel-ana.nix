# batuhan@umay home configuration
{
  lib,
  config,
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

  # Define wallpaper
  myHome.wallpaper.name = "Sunset by the Pier";
}
