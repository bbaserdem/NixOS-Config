# Configuring music playing
{
  config,
  pkgs,
  ...
}: {
  # Import our modules
  imports = [
    ./beets.nix
    ./fluidsynth.nix
    ./listenbrainz.nix
    ./mpd.nix
    ./mpv.nix
    ./ncmpcpp.nix
  ];

  home.packages = [
    # Use cantata as graphical frontend
    pkgs.nur.repos.bandithedoge.cantata
    # Music download tool
    streamrip
  ];
}
