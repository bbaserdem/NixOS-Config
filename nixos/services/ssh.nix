# nixos/services/ssh.nix
# SSH server settings
{pkgs, ...}: {
  services = {
    # SSH server
    openssh = {
      enable = true;
      # Listen on all interfaces (DHCP IP will be assigned dynamically)
      listenAddresses = [
        {
          addr = "0.0.0.0";
          port = 22;
        }
      ];
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        # Security settings
        MaxAuthTries = 3;
        ClientAliveInterval = 300;
        ClientAliveCountMax = 2;
      };
      openFirewall = false; # We handle firewall manually
    };

    # Fail2ban for additional SSH protection
    fail2ban = {
      enable = true;
      maxretry = 3;
      ignoreIP = [
        "127.0.0.0/8"
        "10.0.0.0/8"
        "172.16.0.0/12"
        "192.168.0.0/16"
      ]; # Don't ban private networks
      jails = {
        ssh = {
          settings = {
            enabled = true;
            port = "ssh";
            filter = "sshd";
            logpath = "/var/log/auth.log";
            maxretry = 3;
            findtime = 600;
            bantime = 3600;
            action = "iptables[name=SSH, port=ssh, protocol=tcp]";
          };
        };
      };
    };
  };

  # ALlow wheel users to manage firewall without password
  security.sudo.extraRules = [
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

  # System packages for network management
  environment.systemPackages = with pkgs; [
    # Network tools
    iptables
    nftables

    # Monitoring tools
    nethogs # Per-process network usage
    iftop # Network bandwidth monitoring
    nettools # Connection monitoring, <TODO> this is renamed to net-tools in unstable
    tcpdump # Packet capture

    # Security tools
    fail2ban # Intrusion prevention

    # Basic network utilities
    curl
    wget
    dig
    nmap
  ];
}
