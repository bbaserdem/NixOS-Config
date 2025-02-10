# Configuring ncmpcpp
{
  config,
  ...
}: {

  # TUI Music player
  programs.ncmpcpp = {
    enable = true;
    mpdMusicDir = config.xdg.userDirs.music;
    settings = {
      # Lyrics
      lyrics_directory = "${config.xdg.dataHome}/ncmpcpp/lyrics";
      lyrics_fetchers = "genius, metrolyrics";
      store_lyrics_in_song_dir = false;
      fetch_lyrics_for_current_song_in_background = false;
      follow_now_playing_lyrics = true;
      # Visualizer
      visualizer_data_source = "/tmp/mpd.fifo";
      visualizer_output_name = "FIFO";
      visualizer_in_stereo = true;
      visualizer_type = "ellipse";
      visualizer_look = "▊▊";
      visualizer_color = "magenta, blue, cyan, green, yellow, red";
      # Main UI
      startup_screen = "playlist";
      startup_slave_screen = "visualizer";
      song_window_title_format = "NCMPCPP: ♪ {%A - }{%t}{ (%b)}|{%f}";
      user_interface = "alternative";
      header_visibility = true;
      statusbar_visibility = true;
      progressbar_look = "─╼─";
      now_playing_prefix = "{$3}{$9}$b";
      now_playing_suffix = "$/b{$3}ﱘ{$9}";
      colors_enabled = true;
      empty_tag_color = "cyan";
      color1 = "white";
      color2 = "green";
      statusbar_color = "white";
      progressbar_color = "blue";
      progressbar_elapsed_color = "white";
      main_window_color = "white";
      current_item_prefix = "$(cyan)$r";
      current_item_suffix = "$/r$(end)";
      alternative_ui_separator_color = "cyan";
      alternative_header_first_line_format = "$b$1▊▊▊▊▊$aqqu$/a$9 $8♬ {%t}|{%f} ♬ {$9}$1$atqq$/a▊▊▊▊▊$9$/b";
      alternative_header_second_line_format = "{$5}▊{$9}{{$5$b %a$/b$9}{ {$5}▊{$9}{$8} ♪ {$9}{$6}▊{$9} $6%b$9}{ ($6%y$9)}}|{%D} {$6}{$9}{$6}▊{$9}";
      volume_color = "blue";
      state_flags_color = "cyan";
      header_window_color = "blue";
      state_line_color = "blue";
      # Song view
      song_columns_list_format = "(30)[white]{t|f:Title} (7f)[241]{l} (20)[246]{a} (20)[251]{b} (20)[255]{A}";
      song_status_format = "{{%A{ \"%b\"{ (%y)}} - }{%t}}|{%f}";
      song_list_format = "{$8}{%a - }{%t}|{$8%f$9}$R{$2(%l)$9}";
      song_library_format = "{%n - }{%t}|{%f}";
      # Display modes
      playlist_display_mode = "columns";
      browser_display_mode = "columns";
      search_engine_display_mode = "columns";
      playlist_editor_display_mode = "columns";
      media_library_primary_tag = "album_artist";
      media_library_albums_split_by_date = true;
      # Misc
      autocenter_mode = true;
      centered_cursor = true;
      locked_screen_width_part = 40;
      display_bitrate = true;
      current_item_inactive_column_prefix = "$(magenta)$r";
      current_item_inactive_column_suffix = "$/r$(end)";
      window_border_color = "white_blue";
      active_window_border = "magenta";
      # Tags
      external_editor = "nvim";
      use_console_editor = true;
    };
  };

  # Placeholder file
  xdg.dataFile."ncmpcpp/lyrics/.nomedia".text = "Placeholder for directory creation";

}
