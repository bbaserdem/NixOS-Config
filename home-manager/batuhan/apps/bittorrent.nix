# Deluge VPN configuration
{outputs, ...}: {
  imports = [
    outputs.homeManagerModules.deluge-vpn
  ];
  services.deluge-vpn = {
    enable = true;

    # Directory configuration
    downloadsDir = "Shared/Torrent";
    configDir = ".config/deluge";
    mullvadConfigPath = ".config/mullvad/wg0.conf";

    # Port configuration
    webPort = 8112;
    daemonPort = 58846;

    # Deluge daemon configuration overrides
    coreConfig = {
      # Download/upload limits (KB/s, -1 = unlimited)
      max_download_speed = -1.0;
      max_upload_speed = 1000.0;

      # Connection limits
      max_connections_global = 300;
      max_active_downloading = 5;
      max_active_seeding = 10;
      max_active_limit = 15;

      # Seeding ratios
      stop_seed_at_ratio = true;
      stop_seed_ratio = 3.0;

      # Queue management
      queue_new_to_top = false;
      dont_count_slow_torrents = true;

      # Storage
      pre_allocate_storage = true;
      prioritize_first_last_pieces = true;
    };

    # Web UI configuration overrides
    webConfig = {
      theme = "gray";
      session_timeout = 3600;
      show_session_speed = true;
      sidebar_show_zero = false;
      sidebar_multiple_filters = true;
    };

    # Generate configuration files automatically
    generateConfig = true;
  };
}

