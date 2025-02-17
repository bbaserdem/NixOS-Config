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

  # Use cantata as graphical frontend
  home.packages = [
    pkgs.nur.repos.bandithedoge.cantata
  ];
}
