{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.deluge-vpn;

  # Default Deluge core configuration
  coreConfig = {
    # Network settings
    daemon_port = cfg.daemonPort;
    allow_remote = true;
    listen_ports = [6881 6891];
    listen_interface = "";
    outgoing_interface = "";
    random_port = true;
    listen_use_sys_port = false;
    listen_reuse_port = true;

    # Download settings
    download_location = "/downloads";
    move_completed = false;
    move_completed_path = "/downloads";
    copy_torrent_file = false;
    torrentfiles_location = "/downloads";
    prioritize_first_last_pieces = false;
    pre_allocate_storage = false;

    # Connection limits
    max_connections_global = 200;
    max_upload_speed = -1.0;
    max_download_speed = -1.0;
    max_upload_slots_global = 4;
    max_half_open_connections = 50;
    max_connections_per_second = 20;
    ignore_limits_on_local_network = true;
    max_connections_per_torrent = -1;
    max_upload_slots_per_torrent = -1;
    max_upload_speed_per_torrent = -1;
    max_download_speed_per_torrent = -1;

    # Queue settings
    max_active_seeding = 5;
    max_active_downloading = 3;
    max_active_limit = 8;
    dont_count_slow_torrents = false;
    queue_new_to_top = false;
    auto_managed = true;
    add_paused = false;

    # Ratio/seeding settings
    stop_seed_at_ratio = false;
    remove_seed_at_ratio = false;
    stop_seed_ratio = 2.0;
    share_ratio_limit = 2.0;
    seed_time_ratio_limit = 7.0;
    seed_time_limit = 180;

    # Protocol settings
    dht = true;
    upnp = false;  # Disabled since we're behind VPN
    natpmp = false;  # Disabled since we're behind VPN
    utpex = true;
    lsd = true;

    # Encryption
    enc_in_policy = 1;
    enc_out_policy = 1;
    enc_level = 2;

    # Proxy - will be unused since we route through VPN
    proxy = {
      type = 0;
      hostname = "";
      username = "";
      password = "";
      port = 8080;
      proxy_hostnames = false;
      proxy_peer_connections = false;
      proxy_tracker_connections = false;
      force_proxy = false;
      anonymous_mode = false;
    };

    # Cache settings
    cache_size = 512;
    cache_expiry = 60;

    # Misc
    send_info = false;
    new_release_check = false;
    enabled_plugins = [];
    geoip_db_location = "/usr/share/GeoIP/GeoIP.dat";
    peer_tos = "0x00";
    rate_limit_ip_overhead = true;
    auto_manage_prefer_seeds = false;
    shared = false;
    super_seeding = false;
  } // cfg.coreConfig;

  # Web UI configuration
  webConfig = {
    port = 8112;
    enabled_plugins = [];
    pwd_salt = "c26ab3bbd8b137f99cd83c2c1c0963bcc1a35cad";
    pwd_sha1 = "2ce1a410bcdcc53064129b6d950f2e9fee4edc1e";  # Default password: "deluge"
    session_timeout = 3600;
    sessions = {};
    base = "/";
    interface = "0.0.0.0";
    https = false;
    pkey = "ssl/daemon.pkey";
    cert = "ssl/daemon.cert";
    show_sidebar = true;
    sidebar_show_zero = false;
    sidebar_multiple_filters = true;
    show_session_speed = false;
    show_sidebar = true;
    theme = "gray";
    first_login = false;
    language = "";
  } // cfg.webConfig;

  # Convert Nix attrset to JSON format
  coreConfigJson = builtins.toJSON coreConfig;
  webConfigJson = builtins.toJSON webConfig;

in {
  # Generate core.conf file
  home.file."${cfg.configDir}/core.conf" = lib.mkIf cfg.enable {
    text = coreConfigJson;
  };

  # Generate web.conf file
  home.file."${cfg.configDir}/web.conf" = lib.mkIf cfg.enable {
    text = webConfigJson;
  };

  # Create auth file for daemon
  home.file."${cfg.configDir}/auth" = lib.mkIf cfg.enable {
    text = "localclient::10\n";
  };

  # Create hostlist.conf for web UI
  home.file."${cfg.configDir}/hostlist.conf" = lib.mkIf cfg.enable {
    text = builtins.toJSON [
      ["127.0.0.1" cfg.daemonPort "localclient" ""]
    ];
  };
}