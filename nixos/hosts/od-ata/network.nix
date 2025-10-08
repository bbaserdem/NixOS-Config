{
  config,
  pkgs,
  ...
}: {
  # Enable IP forwarding for VPN routing
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  # Safe network configuration from nixos default
  networking = {
    useNetworkd = true;
    firewall = {
      allowedUDPPorts = [5353 51820]; # mDNS + WireGuard

      # Use nftables backend
      backend = "nftables";

      # Custom nftables rules for WireGuard VPN
      extraInputRules = ''
        # Allow WireGuard traffic
        udp dport 51820 accept
      '';

      extraForwardRules = ''
        # Allow WireGuard clients to access local networks
        iifname "wg0" oifname "end0" ip saddr 10.100.0.0/24 ip daddr { 192.168.0.0/16, 10.0.0.0/8, 172.16.0.0/12 } accept
        iifname "end0" oifname "wg0" ip saddr { 192.168.0.0/16, 10.0.0.0/8, 172.16.0.0/12 } ip daddr 10.100.0.0/24 accept

        # Allow forwarding between WireGuard interface and ethernet
        iifname "wg0" oifname "end0" accept
        iifname "end0" oifname "wg0" accept
      '';
    };

    # NAT configuration for WireGuard VPN
    nat = {
      enable = true;
      externalInterface = "end0";
      internalInterfaces = ["wg0"];

      # Enable masquerading for VPN clients
      extraCommands = ''
        # NAT for WireGuard clients to access internet/local network
        nft add rule ip nat postrouting oifname "end0" ip saddr 10.100.0.0/24 masquerade
      '';

      extraStopCommands = ''
        # Clean up NAT rules
        nft flush table ip nat 2>/dev/null || true
      '';
    };

    nftables = {
      enable = true;

      # Custom ruleset for WireGuard
      tables = {
        wireguard = {
          family = "inet";
          content = ''
            chain forward {
              type filter hook forward priority filter; policy drop;

              # Connection tracking
              ct state established,related accept

              # Allow loopback
              iifname "lo" accept

              # WireGuard forwarding rules
              iifname "wg0" oifname "end0" ip saddr 10.100.0.0/24 accept
              iifname "end0" oifname "wg0" ip daddr 10.100.0.0/24 accept
            }

            chain postrouting {
              type nat hook postrouting priority srcnat; policy accept;

              # Masquerade WireGuard traffic going out ethernet
              oifname "end0" ip saddr 10.100.0.0/24 masquerade
            }
          '';
        };
      };
    };
  };
  systemd.network = {
    networks = {
      "99-ethernet-default-dhcp".networkConfig.MulticastDNS = "yes";
    };
  };

  # Lifted from 'srvos'; don't take down the network for too long when upgrading
  systemd.services = {
    systemd-networkd.stopIfChanged = false;
    systemd-resolved.stopIfChanged = false;
  };
}
