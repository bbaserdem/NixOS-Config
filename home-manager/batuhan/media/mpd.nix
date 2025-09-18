{
  config,
  pkgs,
  lib,
  host,
  ...
}: let
  srcDir =
    if pkgs.stdenv.isLinux
    then config.xdg.userDirs.music
    else "${config.home.homeDirectory}/Media/Music";
in {
  config = lib.mkMerge [
    {
      # MPD configuration
      services.mpd = {
        enable = true;
        musicDirectory = srcDir;
        playlistDirectory = "${srcDir}/Playlists";
        network = {
          listenAddress = "localhost";
          port = 6600;
        };
        extraConfig =
          ''
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
            zeroconf_enabled        "yes"
            zeroconf_name           "MPD @ %h"
            max_connections         "50"
            max_output_buffer_size  "32786"
            # For MPD visualizer
            audio_output {
                type            "fifo"
                name            "FIFO Visualizer"
                path            "/tmp/mpd.fifo"
                format          "44100:16:2"
            }
          ''
          + lib.optionalString pkgs.stdenv.isLinux ''
            # To pulseaudio
            audio_output {
                type            "pipewire"
                name            "PipeWire Sound Server"
            }
          ''
          + lib.optionalString pkgs.stdenv.isDarwin ''
            # To darwin
            audio_output {
                type            "osx"
                name            "CoreAudio"
                mixer_type      "software"
            }
          '';
      };
    }
    (lib.mkIf pkgs.stdenv.isLinux {
      # Media playback keys for mpd, but only for linux
      services.mpdris2 = {
        enable = true;
        mpd = {
          musicDirectory = srcDir;
          host = "localhost";
          port = 6600;
        };
        multimediaKeys = true;
        notifications = false;
      };
    })
  ];
}
