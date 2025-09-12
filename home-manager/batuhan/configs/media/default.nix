# Configuring music playing
{
  outputs,
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
    ./wireplumber.nix
    ./yt-dlp.nix
  ];

  home.packages = [
    outputs.packages.${pkgs.system}.user-audio
    # Use cantata as graphical frontend
    pkgs.cantata
    # Music download tool
    pkgs.streamrip
    # Visualizer
    pkgs.projectm-sdl-cpp
  ];
}
