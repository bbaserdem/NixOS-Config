
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
