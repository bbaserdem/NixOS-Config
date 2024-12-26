# Configuring MPD for joey
{
  config,
  pkgs,
  ...
}: {
  services.mpd = {
    enable = true;
    musicDirectory = "/home/data/Media/Music";
    playlistDirectory = "/home/data/Media/Music/Playlists";
    network = {
      listenAddress = "localhost";
      port = 6601;
    };
    extraConfig = ''
      # Library settings
      auto_update                         "yes"
      auto_update_depth                   "2"
      save_absolute_paths_in_playlists    "no"
      follow_outside_symlinks             "yes"
      follow_inside_symlinks              "no"
      # Playback settings
      restore_paused          "yes"
      metadata_to_use         "albumartist,artist,album,title,track,name,genre,date,composer,performer,disc"
      replaygain              "auto"
      volume_normalization    "no"
      # Server settings
      zeroconf_enabled        "no"
      zeroconf_name           "MPD @ %h"
      max_connections         "50"
      max_output_buffer_size  "32786"
      # For MPD visualizer
      audio_output {
          type            "fifo"
          name            "FIFO Visualizer"
          path            "/tmp/mpd-joey.fifo"
          format          "44100:16:2"
      }
      # To pulseaudio
      audio_output {
          type            "pipewire"
          name            "PipeWire Sound Server"
      }
    '';
  };
  # Media playback keys
  services.mpdris2 = {
    enable = true;
    mpd = {
      musicDirectory = "/home/data/Media/Music";
      host = "localhost";
      port = 6601;
    };
    multimediaKeys = true;
    notifications = false;
  };
}
