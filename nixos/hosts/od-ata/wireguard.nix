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
      peers = [];
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
