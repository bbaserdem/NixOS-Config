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
  environment.etc."wireguard/README.md" = {
    text = ''
      # WireGuard VPN Management

      ## Server Setup (First Time)

      1. Generate server private key:
         ```bash
         sudo mkdir -p /etc/wireguard
         sudo wg genkey | sudo tee /etc/wireguard/private
         sudo chmod 600 /etc/wireguard/private
         ```

      2. Start WireGuard service:
         ```bash
         sudo systemctl enable --now systemd-networkd-wait-online
         sudo systemctl enable --now wg-quick@wg0
         ```

      ## Client Management (Dynamic - No NixOS Rebuilds)

      ### Add a new client:
      ```bash
      sudo wireguard-add-client <client-name> [optional-ip]
      ```

      Examples:
      ```bash
      # Auto-assign IP
      sudo wireguard-add-client laptop

      # Specify IP
      sudo wireguard-add-client phone 10.100.0.5
      ```

      ### Remove a client:
      ```bash
      sudo wireguard-remove-client <client-name>
      ```

      ### List all clients:
      ```bash
      sudo wireguard-list-clients
      ```

      ### Generate QR code for mobile clients:
      ```bash
      # Install qrencode first: nix-shell -p qrencode
      qrencode -t ansiutf8 < /etc/wireguard/clients/<client-name>.conf
      ```

      ## Network Configuration

      - Server IP: 10.100.0.1/24
      - Client IPs: 10.100.0.2-254/24 (auto-assigned)
      - Port: 51820/udp
      - Access to local networks: 192.168.x.x, 10.x.x.x, 172.16-31.x.x

      ## Persistent Peer Configuration

      Client configurations are stored in `/etc/wireguard/clients/` but peers
      are added dynamically using the `wg` command. To make peer configurations
      persistent across reboots, they are automatically saved to the interface.

      ## Troubleshooting

      - Check server status: `sudo wg show`
      - Check interface status: `sudo systemctl status wg-quick@wg0`
      - View logs: `sudo journalctl -u wg-quick@wg0`
      - Test connectivity: `ping 10.100.0.1` (from client)
    '';
  };
}

