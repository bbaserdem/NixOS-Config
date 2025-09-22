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

  # Define wallpaper
  myHome.wallpaper.name = "Photo by SpaceX";
}
