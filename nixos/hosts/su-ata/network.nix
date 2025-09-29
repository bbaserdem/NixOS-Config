# nixos/hosts/su-ata/network.nix
{
  config,
  lib,
  pkgs,
  ...
}: let
  macAddress = "10:ff:e0:8c:3d:0c";
in {
  # Network config for systemd
  systemd = {
    network = {
      enable = true;

      # Wait for network to be online before considering boot complete
      wait-online = {
        enable = true;
        anyInterface = true; # Don't wait for all interfaces, just any working one
      };

      # Link configuration for predictable interface naming
      links."10-ethernet" = {
        matchConfig = {
          MACAddress = macAddress;
        };
        linkConfig = {
          Name = "eth0"; # Predictable interface name
        };
      };

      # Match specific ethernet interface by MAC and configure DHCP
      networks."10-ethernet" = {
        matchConfig = {
          MACAddress = macAddress; # Match specific ethernet interface
        };
        networkConfig = {
          DHCP = "ipv4"; # Use DHCP for IPv4
          DNS = ["1.1.1.1" "8.8.8.8"]; # Fallback DNS servers

          # Network configuration options
          IPv6AcceptRA = false; # Disable IPv6 router advertisements
          LinkLocalAddressing = "no"; # Disable link-local addressing
        };
        linkConfig = {
          RequiredForOnline = "routable"; # Wait until interface is routable
        };
      };
    };

    # Networkmanager doesn't do this automatically, we should do it
    resolved = {
      enable = true;
      extraConfig = ''
        MulticastDNS=yes
      '';
    };
  };

  # Network configuration with static IP
  networking = {
    networkmanager.enable = false;
    useDHCP = false;

    # Use nftables with custom ruleset
    nftables = {
      enable = true;
      rulesetFile = ./firewall.nft;
    };

    # Disable the built-in firewall since we're using custom nftables
    firewall.enable = lib.mkForce false;
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
              command = "${pkgs.nftables}/bin/nft";
              options = ["NOPASSWD"];
            }
            {
              command = "${pkgs.systemd}/bin/systemctl restart fail2ban";
              options = ["NOPASSWD"];
            }
            {
              command = "${pkgs.systemd}/bin/systemctl restart nftables";
              options = ["NOPASSWD"];
            }
          ];
        }
      ];
    };
  };

  # Kernel security settings
  boot.kernel.sysctl = {
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
