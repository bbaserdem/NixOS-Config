# nixos/hosts/su-ata/network.nix
{
  config,
  lib,
  pkgs,
  ...
}: {
  # Network config for systemd
  systemd.network = {
    enable = true;

    # Wait for network to be online before considering boot complete
    wait-online = {
      enable = true;
      anyInterface = true; # Don't wait for all interfaces, just any working one
    };

    # Match any ethernet interface and configure static IP
    networks."10-ethernet" = {
      matchConfig = {
        Name = "en* eth*"; # Match any ethernet interface
      };
      networkConfig = {
        DHCP = "no";
        Address = ["192.168.1.100/24"];
        Gateway = "192.168.1.1";
        DNS = ["1.1.1.1" "8.8.8.8"];

        # Network configuration options
        IPv6AcceptRA = false; # Disable IPv6 router advertisements
        LinkLocalAddressing = "no"; # Disable link-local addressing
      };
      linkConfig = {
        RequiredForOnline = "routable"; # Wait until interface is routable
      };
    };
  };

  # Network configuration with static IP
  networking = {
    networkmanager.enable = false;
    useDHCP = false;

    # Use nftables (modern firewall backend)
    nftables.enable = true;

    # Firewall configuration
    firewall = {
      enable = true;

      # Basic ports for local network access only
      allowedTCPPorts = [
        22 # SSH
        443 # HTTPS (Traefik)
        8384 # Syncthing Web UI (fallback)
      ];

      allowedUDPPorts = [
        21027 # Syncthing discovery
        22000 # Syncthing data
      ];

      # Outbound filtering - Development mode (controlled internet access)
      extraCommands = ''
        # Flush any existing OUTPUT rules
        iptables -F OUTPUT 2>/dev/null || true
        iptables -P OUTPUT DROP

        # Allow loopback
        iptables -A OUTPUT -o lo -j ACCEPT

        # Allow established and related connections
        iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

        # Allow local network traffic
        iptables -A OUTPUT -d 192.168.1.0/24 -j ACCEPT

        # Restrict inbound services to local network only
        iptables -I INPUT 1 -i lo -j ACCEPT
        iptables -I INPUT 2 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
        iptables -I INPUT 3 -s 192.168.1.0/24 -p tcp --dport 22 -j ACCEPT
        iptables -I INPUT 4 -s 192.168.1.0/24 -p tcp --dport 443 -j ACCEPT
        iptables -I INPUT 5 -s 192.168.1.0/24 -p tcp --dport 8384 -j ACCEPT
        iptables -I INPUT 6 -s 192.168.1.0/24 -p udp --dport 21027 -j ACCEPT
        iptables -I INPUT 7 -s 192.168.1.0/24 -p udp --dport 22000 -j ACCEPT
        iptables -I INPUT 8 -j LOG --log-prefix "INPUT_BLOCKED: " --log-level 4
        iptables -I INPUT 9 -j DROP

        # Essential services for Nix operations
        iptables -A OUTPUT -p udp --dport 53 -j ACCEPT    # DNS
        iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT    # DNS over TCP
        iptables -A OUTPUT -p udp --dport 123 -j ACCEPT   # NTP

        # Development services (no rate limiting for smooth development)
        iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT    # HTTP
        iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT   # HTTPS
        iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT    # SSH (for git)
        iptables -A OUTPUT -p tcp --dport 9418 -j ACCEPT  # Git protocol

        # Log blocked outbound connections
        iptables -A OUTPUT -j LOG --log-prefix "DEV_BLOCKED: " --log-level 4
        iptables -A OUTPUT -j DROP
      '';

      # Clean up rules when firewall stops
      extraStopCommands = ''
        iptables -P OUTPUT ACCEPT 2>/dev/null || true
        iptables -P INPUT ACCEPT 2>/dev/null || true
        iptables -F OUTPUT 2>/dev/null || true
        iptables -F INPUT 2>/dev/null || true
      '';

      # Additional security settings
      logRefusedConnections = true;
      logRefusedPackets = true;
      logRefusedUnicastsOnly = false;

      # Reverse path filtering (anti-spoofing)
      checkReversePath = "strict";
    };
  };

  # Security services
  services = {
    # Time synchronization (requires internet)
    chrony = {
      enable = true;
      servers = ["pool.nix.org"];
    };
  };

  # System security hardening
  security = {
    # Sudo configuration
    sudo = {
      wheelNeedsPassword = true;
      extraRules = [
        {
          groups = ["wheel"];
          commands = [
            # Allow wheel users to manage firewall without password
            {
              command = "${pkgs.iptables}/bin/iptables";
              options = ["NOPASSWD"];
            }
            {
              command = "${pkgs.systemd}/bin/systemctl restart fail2ban";
              options = ["NOPASSWD"];
            }
          ];
        }
      ];
    };

    # Kernel security settings
    kernel.sysctl = {
      # Network security
      "net.ipv4.ip_forward" = 0;
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.default.send_redirects" = 0;
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv4.conf.default.accept_source_route" = 0;

      # IP spoofing protection
      "net.ipv4.conf.all.rp_filter" = 1;
      "net.ipv4.conf.default.rp_filter" = 1;

      # ICMP redirect acceptance
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;

      # Log suspicious packets
      "net.ipv4.conf.all.log_martians" = 1;
      "net.ipv4.conf.default.log_martians" = 1;

      # Ignore ping requests (optional - uncomment if desired)
      # "net.ipv4.icmp_echo_ignore_all" = 1;
    };
  };

  # Logging configuration
  services.journald = {
    extraConfig = ''
      SystemMaxUse=2G
      MaxRetentionSec=1week
      ForwardToSyslog=yes
      Storage=persistent
    '';
  };
}
