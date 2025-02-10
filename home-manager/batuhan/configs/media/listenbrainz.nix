# Configuring Scrobbler
{
  config,
  ...
}: {

  # Scrobbler token
  sops.secrets.listenbrainz = {};

  # Scrobbler
  services.listenbrainz-mpd = {
    enable = true;
    settings = {
      submission = {
        token_file = config.sops.secrets.listenbrainz.path;
        cache_file = "${config.xdg.cacheHome}/mpd/listenbrainz-mpd-cache.sqlite3";
      };
    };
  };

}
