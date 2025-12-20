{pkgs, ...}:
pkgs.writeShellScript "vpn-startup" ''
  set -e

  # Load wireguard module if not loaded
  modprobe wireguard || true

  # Enable IP forwarding
  echo 1 > /proc/sys/net/ipv4/ip_forward

  # Start WireGuard
  ${pkgs.wireguard-tools}/bin/wg-quick up wg0

  # Set up nftables to block all traffic except through VPN
  ${pkgs.nftables}/bin/nft flush ruleset

  # Create table and chains
  ${pkgs.nftables}/bin/nft add table inet filter
  ${pkgs.nftables}/bin/nft add chain inet filter input { type filter hook input priority 0\; policy drop\; }
  ${pkgs.nftables}/bin/nft add chain inet filter forward { type filter hook forward priority 0\; policy drop\; }
  ${pkgs.nftables}/bin/nft add chain inet filter output { type filter hook output priority 0\; policy drop\; }

  # Allow loopback
  ${pkgs.nftables}/bin/nft add rule inet filter input iif lo accept
  ${pkgs.nftables}/bin/nft add rule inet filter output oif lo accept

  # Allow established connections
  ${pkgs.nftables}/bin/nft add rule inet filter input ct state established,related accept
  ${pkgs.nftables}/bin/nft add rule inet filter output ct state established,related accept

  # Allow VPN interface traffic
  ${pkgs.nftables}/bin/nft add rule inet filter output oifname wg0 accept
  ${pkgs.nftables}/bin/nft add rule inet filter input iifname wg0 accept

  # Allow local network traffic (adjust subnets as needed)
  ${pkgs.nftables}/bin/nft add rule inet filter output ip daddr 192.168.0.0/16 accept
  ${pkgs.nftables}/bin/nft add rule inet filter output ip daddr 172.16.0.0/12 accept
  ${pkgs.nftables}/bin/nft add rule inet filter output ip daddr 10.0.0.0/8 accept

  # Block everything else (kill switch)
  ${pkgs.nftables}/bin/nft add rule inet filter output drop

  echo "VPN started successfully with nftables kill switch"

  # Keep container running and monitor VPN
  while true; do
    if ! ${pkgs.wireguard-tools}/bin/wg show wg0 > /dev/null 2>&1; then
      echo "VPN connection lost, exiting..."
      exit 1
    fi
    sleep 30
  done
''