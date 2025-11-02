# nixos/hosts/od-ata/wireguard.nix
# WireGuard VPN server configuration for local network access
{
  config,
  pkgs,
  lib,
  outputs,
  ...
}: {
  # WireGuard server configuration
  networking.wireguard.interfaces = {
    wg0 = {
      # Determines the IP address and subnet of the server's end of the tunnel interface
      ips = ["10.100.0.1/24"];

      # The port that WireGuard listens to. Must be accessible by the client
      listenPort = 51820;

      # Path to the private key file, as a string
      privateKeyFile = config.sops.secrets."wireguard/private/od-ata".path;

      # Peers are managed dynamically using wg command, not in NixOS config
      peers = [
        {
          name = "od-ata";
          publicKey = "9JZyVGNWJhkIWFxxcOcqYg4zzqs+EJ12/AQd+jwa0AE=";
          allowedIPs = ["10.100.0.0/24"];
          presharedKeyfile = config.sops.secrets."wireguard/preshared/od-ata/od-ata".path;
        }
        {
          name = "su-ana";
          publicKey = "VILvBUQ2QhzbElggn7ucZwqKtkRBAh1mTH67lqGsbgs=";
          allowedIPs = ["10.100.0.0/24"];
          presharedKeyfile = config.sops.secrets."wireguard/preshared/od-ata/su-ana".path;
        }
        {
          name = "su-ata";
          publicKey = "yghguVcCM3M2luZqnxK1W5Dc0foNUiv9w7/KICllSHI=";
          allowedIPs = ["10.100.0.0/24"];
          presharedKeyfile = config.sops.secrets."wireguard/preshared/od-ata/su-ata".path;
        }
        {
          name = "umay";
          publicKey = "Gsns044B7Ko+qO/+KCqQJQlHAvoTBbYowvbV0Ju83VQ=";
          allowedIPs = ["10.100.0.0/24"];
          presharedKeyfile = config.sops.secrets."wireguard/preshared/od-ata/umay".path;
        }
        {
          name = "yel-ana";
          publicKey = "rv7/yz5zO9QYqB7iCl7nHehn+xEPZUB90IgLIOyJKG8=";
          allowedIPs = ["10.100.0.0/24"];
          presharedKeyfile = config.sops.secrets."wireguard/preshared/od-ata/yel-ana".path;
        }
        {
          name = "yertengri";
          publicKey = "F312+qWkfs+WjYW8/DhtVACQeL2x4L+vRzTUjQj6Vi8=";
          allowedIPs = ["10.100.0.0/24"];
          presharedKeyfile = config.sops.secrets."wireguard/preshared/od-ata/yertengri".path;
        }
        {
          name = "erlik";
          publicKey = "spHODlp8m++x+EKFMq12GypzLQSDYwwRewee4Kaiahw=";
          allowedIPs = ["10.100.0.0/24"];
          presharedKeyfile = config.sops.secrets."wireguard/preshared/od-ata/erlik".path;
        }
      ];
    };
  };

  # Install WireGuard tools and management scripts
  environment.systemPackages = with pkgs; [
    wireguard-tools
    qrencode
    user-wireguard
  ];

  # Log rotation for WireGuard
  services.logrotate = {
    enable = true;
    settings = {
      "/var/log/wireguard.log" = {
        frequency = "weekly";
        rotate = 4;
        compress = true;
        delaycompress = true;
        missingok = true;
        notifempty = true;
        create = "644 root root";
      };
    };
  };

  # Instructions for dynamic key management
  environment.etc."wireguard/README.md".source = ./WireguardReadme.md;
}
