# Beets configuration
{
  config,
  pkgs,
  ...
}: let
  musicDir = config.services.mpd.musicDirectory;
  playlistDir = config.services.mpd.playlistDirectory;
in {
  programs.beets.settings = {
    directory = musicDir;
    library = "${musicDir}/Beets_Library.db";
    ignore_hidden = false;
    asciify_paths = false;
    path_sep_replace = "⌿";
    replace = {
      "^-" = "_"; # Replace leading dash
      "^/" = ""; # Remove leading directory creator
      "^\\." = ""; # Remove leading dots
      "^\\s+" = ""; # remove trailing white-space
      "\\s+\$" = ""; # remove ending white-space
      "[\\x00-\\x1f]" = ""; # Remove control characters
      "<" = "＜"; # Windows/Android restricted characters
      ">" = "＞";
      ":" = "∶";
      "\"" = "″";
      "\\?" = "⁇";
      "\\*" = "✱";
      "\\|" = "￨";
      "\\\\" = "⍀";
      "\\.\\.\\." = "…"; # Other replacements
      "&" = "＆";
    };
    threaded = true;
    sort_item = [
      "albumartist+"
      "artist+"
      "album+"
      "disc+"
      "track+"
    ];
    sort_case_insensitive = false;
    artist_credit = true;
    per_disc_numbering = true;
    # UI options
    ui = {
      color = true;
    };
    # Importer options
    import = {
      write = true;
      move = true;
      resume = "ask";
      from_scratch = false;
      quiet = false;
      quiet_fallback = "asis";
      log = "${config.xdg.cacheHome}/beets/log";
      default_action = "skip";
      languages = [
        "en"
        "tr"
        "jp"
      ];
      detail = false;
      duplicate_action = "ask";
      bell = true;
    };
    # Database options
    musicbrainz = {
      searchlimit = 10;
      extra_tags = [
        "year"
        "catalognum"
        "country"
        "media"
        "label"
      ];
      genre = true;
      external_ids = {
        discogs = "yes";
        bandcamp = "yes";
        deezer = "yes";
      };
      user = "silverbluep";
      pass = "";
    };
    # Autotagger matching
    match = {
      strong_rec_thresh = 0.04;
    };
    # Path specifications
    paths = {
      default = "\${initial}/%tdot{%the{\${albumartist}}}/%if{\${division},\${division}/}%if{$date,[\${date}] }%tdot{\${album}%aunique{albumartist album,albumdisambig}}/%if{\${tracknumber},\${tracknumber}. }\${title} - \${artist}";
      comp = "\${initial}/%tdot{%the{\${albumartist}}}/%if{\${division},\${division}/}%if{$date,[\${date}] }%tdot{\${album}%aunique{albumartist album,albumdisambig}}/%if{\${tracknumber},\${tracknumber}. }\${title} - \${artist}";
      singleton = "[\${initial}]/%tdot{%the{\${albumartist}}}/%if{$date,[\${date}] }\${title} - \${artist}";
    };
    # Plugins
    pluginpath = "${config.xdg.dataHome}/beets/beetsplug";
    plugins = [
      # Metadata sources
      "musicbrainz"
      "discogs"
      "deezer"
      "beatport"
      "spotify"
      # Builtin plugins
      "advancedrewrite"
      "albumtypes"
      "autobpm"
      "badfiles"
      "convert"
      "duplicates"
      "info"
      "missing"
      "edit"
      "fetchart"
      "embedart"
      "importadded"
      "importfeeds"
      "lastgenre"
      "lyrics"
      "mbsync"
      "replaygain"
      "playlist"
      "smartplaylist"
      "the"
      "thumbnails"
      "types"
      "zero"
      # External plugins
      "sbp"
      "alternatives"
      "copyartifacts"
    ];
    # Plugin configs
    advancedrewrite = [
      {
        match = "artist:\"Oh Sees\"";
        replacements = {
          albumartist = "Osees";
        };
      }
    ];
    autobpm = {
      auto = false;
      overwrite = false;
    };
    badfiles = {
      check_on_import = true;
      commands = {
        flac = "flac --test --warnings-as-errors --silent";
      };
    };
    convert = {
      auto = false;
      copy_album_art = true;
      album_art_maxwidth = 256;
      dest = "${config.xdg.userDirs.extraConfig.XDG_MEDIA_DIR}/Music (Lossy)";
      never_convert_lossy_files = true;
      embed = true;
      delete_originals = false;
      format = "opus";
      formats = {
        opus = {
          command = "${pkgs.user-audio}/bin/audio-convert2opus $source $dest";
          extension = "opus";
        };
      };
    };
    embedart = {
      auto = true;
      ifempty = false;
      maxwidth = 256;
      remove_art_file = false;
    };
    fetchart = {
      auto = true;
      sources = [
        "filesystem"
        "coverart: release"
        "itunes"
        "coverart: releasegroup"
        "albumart"
        "amazon"
        "wikipedia"
        "*"
      ];
      high_resolution = true;
      store_source = true;
    };
    importfeeds = {
      formats = "m3u_session";
      dir = playlistDir;
      relative_to = musicDir;
      m3u_name = "Import-";
    };
    lastgenre = {
      auto = true;
      force = false;
      keep_existing = true;
      source = "album";
    };
    lyrics = {
      auto = true;
      force = false;
      sources = [
        "lrclib"
        "genius"
      ];
      synced = true;
    };
    mpd = {
      rating = true;
      host = config.services.mpd.network.listenAddress;
      port = config.services.mpd.network.port;
    };
    replaygain = {
      auto = true;
      backend = "ffmpeg";
      overwrite = false;
    };
    playlist = {
      auto = true;
      playlist_dir = playlistDir;
      relative_to = musicDir;
    };
    smartplaylist = {
      auto = true;
      playlist_dir = playlistDir;
      relative_to = musicDir;
      playlists = [
        {
          name = "JoeyFavs.m3u";
          album_query = "introducer:Joseph Hirsh";
          query = "introducer:Joseph Hirsh";
        }
        {
          name = "Mood-Instrumental.m3u";
          album_query = "mood:instrumental";
        }
        {
          name = "Mood-Microtonal.m3u";
          album_query = "mood:microtonal";
        }
        {
          name = "Mood-Affirmation.m3u";
          album_query = "mood:affirmation";
        }
        {
          name = "Mood-Heavy.m3u";
          album_query = "mood:heavy";
        }
        {
          name = "Mood-Turkish.m3u";
          album_query = "mood:turkish";
        }
        {
          name = "Mood-Japanese.m3u";
          album_query = "mood:japanese";
        }
        {
          name = "Mood-Ambient.m3u";
          album_query = "mood:ambient";
        }
        {
          name = "Mood-Electronic.m3u";
          album_query = "mood:electronic";
        }
        {
          name = "Mood-Space.m3u";
          album_query = "mood:space";
        }
        {
          name = "Mood-Phonk.m3u";
          album_query = "mood:phonk";
        }
        {
          name = "Mood-Trippy.m3u";
          album_query = "mood:trippy";
        }
        {
          name = "Mood-Gag.m3u";
          album_query = "mood:gag";
        }
      ];
    };
    thumbnails = {
      auto = true;
      force = false;
    };
    types = {
      phone = "bool";
      dap = "bool";
      game = "bool";
    };
    zero = {
      auto = true;
      comments = [
        "EAC"
        "LAME"
        "from.+collection"
        "ripped by"
      ];
      fields = "comments";
      update_database = true;
    };
    # External plugins
    copyartifacts = {
      extensions = ".*";
      print_ignored = "yes";
    };
    alternatives = {
      phone = {
        directory = "${config.xdg.userDirs.extraConfig.XDG_PHONE_DIR}/Music";
        formats = "opus mp3 ogg";
        query = "phone:True";
        removable = false;
      };
    };
  };
}
