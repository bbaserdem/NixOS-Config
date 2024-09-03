# YT-DLP config
{
  config,
  pkgs,
  ...
}: {
  # YT-DLP settings
  programs.yt-dlp = {
    enable = true;
    package = pkgs.yt-dlp;
    settings = {
      # General options
      default-search = "youtube:1";
      live-from-start = true;
      color = "auto";
      # Video selection
      yes-playlist = true;
      # Download options
      concurrent-fragments = 5;
      # Filesystem options
      paths = "home:${config.xdg.userDirs.download}/Videos/Youtube-dlp";
      output = "%(title)s-%(resolution)s.$(ext)s";
      restrict-filenames = true;
      no-overwrites = true;
      write-description = true;
      write-info-json = true;
      clean-info-json = true;
      cache-dir = "${config.xdg.cacheHome}/yt-dlp";
      # Thumbnail options
      write-thumbnail = true;
      # Subtitle options
      write-subs = true;
      write-auto-subs = true;
      sub-langs = "en.*,tr.*,tur.*";
      # Post processing
      audio-format = "best";
      audio-quality = 0;
      embed-subs = true;
      embed-thumbnail = true;
      embed-metadata = true;
      embed-chapters = true;
      # Sponsorblock
      sponsorblock-mark = "all";
    };
    extraConfig = ''
      --paths temp:/tmp/yt-dlp
    '';
  };
}
