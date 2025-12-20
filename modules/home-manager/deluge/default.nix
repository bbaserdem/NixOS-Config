# Deluge torrent daemon with mandatory Mullvad VPN using Nix-built Docker images
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.deluge-vpn;

  # Import scripts
  loadImages = import ./load-images.nix {inherit pkgs;};
  checkScript = import ./check.nix {inherit pkgs;};
  logsScript = import ./logs.nix {inherit pkgs;};
in {
  imports = [
    ./deluge-config.nix
  ];
  options.services.deluge-vpn = {
    enable = lib.mkEnableOption "Deluge torrent daemon with Mullvad VPN";

    downloadsDir = lib.mkOption {
      type = lib.types.str;
      default = "Shared/Torrent";
      description = "Directory for torrent downloads, relative to home directory";
    };

    configDir = lib.mkOption {
      type = lib.types.str;
      default = ".config/deluge";
      description = "Directory for Deluge configuration, relative to home directory";
    };

    mullvadConfigPath = lib.mkOption {
      type = lib.types.str;
      default = ".config/mullvad/wg0.conf";
      description = "Path to Mullvad WireGuard configuration file, relative to home directory";
    };

    webPort = lib.mkOption {
      type = lib.types.int;
      default = 8112;
      description = "Port for Deluge web interface";
    };

    daemonPort = lib.mkOption {
      type = lib.types.int;
      default = 58846;
      description = "Port for Deluge daemon";
    };

    coreConfig = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Additional Deluge core configuration options to override defaults";
      example = {
        max_download_speed = 1000;
        max_upload_speed = 500;
        stop_seed_at_ratio = true;
        stop_seed_ratio = 2.0;
      };
    };

    webConfig = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Additional Deluge web UI configuration options to override defaults";
      example = {
        theme = "dark";
        session_timeout = 7200;
      };
    };

    generateConfig = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to generate Deluge configuration files automatically";
    };
  };

  config = lib.mkIf cfg.enable {
    # Load images into Docker
    systemd.user.services.deluge-vpn-load-images = {
      Unit = {
        Description = "Load Deluge VPN Docker images";
        After = ["docker.service"];
        Requires = ["docker.service"];
      };

      Service = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${loadImages}/bin/load-deluge-vpn-images";
      };

      Install.WantedBy = ["default.target"];
    };

    # VPN container service
    systemd.user.services.deluge-vpn-wireguard = {
      Unit = {
        Description = "Deluge VPN WireGuard container";
        After = ["deluge-vpn-load-images.service"];
        Requires = ["deluge-vpn-load-images.service"];
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.docker}/bin/docker run --rm --name deluge-vpn-wireguard --cap-add=NET_ADMIN --cap-add=SYS_MODULE --sysctl net.ipv4.conf.all.src_valid_mark=1 --sysctl net.ipv6.conf.all.disable_ipv6=1 -v ${config.home.homeDirectory}/${cfg.mullvadConfigPath}:/etc/wireguard/wg0.conf:ro -v /lib/modules:/lib/modules:ro -p ${toString cfg.webPort}:8112 -p ${toString cfg.daemonPort}:58846 deluge-vpn-wireguard:latest";
        ExecStop = "${pkgs.docker}/bin/docker stop deluge-vpn-wireguard";
        Restart = "always";
        RestartSec = "10";
      };

      Install.WantedBy = ["default.target"];
    };

    # Deluge daemon container service
    systemd.user.services.deluge-daemon = {
      Unit = {
        Description = "Deluge daemon container";
        After = ["deluge-vpn-wireguard.service"];
        Requires = ["deluge-vpn-wireguard.service"];
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.docker}/bin/docker run --rm --name deluge-daemon --network container:deluge-vpn-wireguard -v ${config.home.homeDirectory}/${cfg.configDir}:/config -v ${config.home.homeDirectory}/${cfg.downloadsDir}:/downloads deluge-daemon:latest";
        ExecStop = "${pkgs.docker}/bin/docker stop deluge-daemon";
        Restart = "always";
        RestartSec = "10";
      };

      Install.WantedBy = ["default.target"];
    };

    # Deluge web UI container service
    systemd.user.services.deluge-web = {
      Unit = {
        Description = "Deluge web UI container";
        After = ["deluge-daemon.service"];
        Requires = ["deluge-daemon.service"];
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.docker}/bin/docker run --rm --name deluge-web --network container:deluge-vpn-wireguard -v ${config.home.homeDirectory}/${cfg.configDir}:/config deluge-web:latest";
        ExecStop = "${pkgs.docker}/bin/docker stop deluge-web";
        Restart = "always";
        RestartSec = "10";
      };

      Install.WantedBy = ["default.target"];
    };

    home.packages = [
      loadImages
      checkScript
      logsScript
    ];
  };
}