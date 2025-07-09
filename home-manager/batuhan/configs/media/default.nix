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
    ./wireplumber.nix
  ];

  home.packages = with pkgs; [
    # Use cantata as graphical frontend
    #pkgs.nur.repos.bandithedoge.cantata
    cantata
    # Music download tool
    streamrip
  ];
}
