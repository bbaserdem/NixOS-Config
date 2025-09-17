# nixos/hosts/su-ata/traefik.nix
# Web server setup for server
{
  config,
  pkgs,
  host,
  ...
}: let
  fqdn = "${host}.local";
  staticIP = "192.168.1.100"; # You might want to make this configurable too
in {
  # Create Traefik users file from sops secrets using systemd service.
  systemd.services.traefik-auth-setup = {
    description = "Generate Traefik authentication file from sops secrets";
    wantedBy = ["traefik.service"];
    before = ["traefik.service"];
    after = ["sops-nix.service"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "root"; # Need root to read sops secrets
    };
    script = ''
      # Read username and password from sops secrets
      USERNAME=$(cat ${config.sops.secrets."traefik/username".path})
      PASSWORD=$(cat ${config.sops.secrets."traefik/password".path})

      # Generate htpasswd entry
      HTPASSWD_ENTRY=$(${pkgs.apacheHttpd}/bin/htpasswd -nb "$USERNAME" "$PASSWORD")

      # Create users file
      mkdir -p /etc/traefik
      echo "$HTPASSWD_ENTRY" > /etc/traefik/users
      chown traefik:traefik /etc/traefik/users
      chmod 600 /etc/traefik/users

      echo "Traefik authentication file updated for user: $USERNAME"
    '';

    # Restart Traefik when secrets change
    restartTriggers = [
      config.sops.secrets."traefik/username".path
      config.sops.secrets."traefik/password".path
    ];
  };

  # Traefik reverse proxy configuration
  # Traefik reverse proxy configuration
  services.traefik = {
    enable = true;

    # Static configuration
    staticConfigOptions = {
      # Entry points (where Traefik listens)
      entryPoints = {
        web = {
          address = ":80";
          # Redirect HTTP to HTTPS
          http.redirections.entrypoint = {
            to = "websecure";
            scheme = "https";
            permanent = true;
          };
        };
        websecure = {
          address = ":443";
        };
      };

      # Certificate configuration (self-signed only)
      # Self-signed certificates will be loaded from file provider

      # TLS configuration for self-signed certificates
      tls = {
        options = {
          default = {
            minVersion = "VersionTLS12";
            cipherSuites = [
              "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384"
              "TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305"
              "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256"
            ];
          };
        };

        # Load certificates from files
        certificates = [
          {
            certFile = "/var/lib/traefik/ssl/${host}.crt";
            keyFile = "/var/lib/traefik/ssl/${host}.key";
          }
        ];
      };

      # API and Dashboard
      api = {
        dashboard = true;
        insecure = false; # Secure dashboard through auth
      };

      # Logging
      log = {
        level = "INFO";
        filePath = "/var/log/traefik/traefik.log";
      };

      accessLog = {
        filePath = "/var/log/traefik/access.log";
        format = "json";
      };

      # Metrics (optional)
      metrics = {
        prometheus = {
          addEntryPointsLabels = true;
          addServicesLabels = true;
        };
      };

      # File provider for dynamic configuration
      providers = {
        file = {
          filename = "/etc/traefik/dynamic.yml";
          watch = true;
        };
      };
    };
  };

  # Create dynamic configuration file with sops credentials
  environment.etc."traefik/dynamic.yml" = {
    mode = "0644";
    user = "traefik";
    group = "traefik";
    text = ''
      # Dynamic configuration for Traefik
      http:
        middlewares:
          # Basic authentication middleware using sops credentials
          auth:
            basicAuth:
              usersFile: /etc/traefik/users

          # Security headers middleware
          security:
            headers:
              frameDeny: true
              sslRedirect: true
              browserXssFilter: true
              contentTypeNosniff: true
              forceSTSHeader: true
              stsIncludeSubdomains: true
              stsPreload: true
              stsSeconds: 31536000

          # Rate limiting middleware (optional)
          ratelimit:
            rateLimit:
              burst: 100
              average: 50

        # Services (backend definitions)
        services:
          # Landing page service (to be created)
          landing:
            loadBalancer:
              servers:
                - url: "http://127.0.0.1:3000"

          # Jupyter Lab service
          jupyter:
            loadBalancer:
              servers:
                - url: "http://127.0.0.1:8888"

          # Syncthing service
          syncthing:
            loadBalancer:
              servers:
                - url: "http://127.0.0.1:8384"

          # Traefik dashboard service (self-reference)
          traefik:
            loadBalancer:
              servers:
                - url: "http://127.0.0.1:8080"

        # Routes (URL routing rules)
        routers:
          # Landing page (root)
          landing:
            rule: "Host(`${fqdn}`) || Host(`${staticIP}`)"
            service: "landing"
            entryPoints:
              - "websecure"
            middlewares:
              - "auth"
              - "security"
            tls: true

          # Jupyter Lab
          jupyter:
            rule: "(Host(`${fqdn}`) || Host(`${staticIP}`)) && PathPrefix(`/jupyter`)"
            service: "jupyter"
            entryPoints:
              - "websecure"
            middlewares:
              - "auth"
              - "security"
            tls: true

          # Syncthing
          syncthing:
            rule: "(Host(`${fqdn}`) || Host(`${staticIP}`)) && PathPrefix(`/syncthing`)"
            service: "syncthing"
            entryPoints:
              - "websecure"
            middlewares:
              - "auth"
              - "security"
            tls: true

          # Traefik dashboard
          dashboard:
            rule: "(Host(`${fqdn}`) || Host(`${staticIP}`)) && (PathPrefix(`/api`) || PathPrefix(`/dashboard`))"
            service: "api@internal"
            entryPoints:
              - "websecure"
            middlewares:
              - "auth"
              - "security"
            tls: true
    '';
  };

  # System configuration for Traefik
  systemd.services.traefik = {
    serviceConfig = {
      # Security settings
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectHome = true;
      ProtectSystem = "strict";
      ReadWritePaths = [
        "/var/lib/traefik"
        "/var/log/traefik"
      ];

      # Network settings
      IPAddressDeny = "any";
      IPAddressAllow = [
        "127.0.0.0/8"
        "192.168.1.0/24" # Adjust to your local network
      ];
    };

    # Ensure directories exist
    preStart = ''
      mkdir -p /var/lib/traefik
      mkdir -p /var/log/traefik
      chown traefik:traefik /var/lib/traefik /var/log/traefik
      chmod 700 /var/lib/traefik
      chmod 755 /var/log/traefik
    '';
  };

  # User and group for Traefik
  users.users.traefik = {
    isSystemUser = true;
    group = "traefik";
    home = "/var/lib/traefik";
    createHome = true;
  };
  users.groups.traefik = {};

  # Firewall configuration for Traefik
  networking.firewall = {
    allowedTCPPorts = [80 443];

    # Only allow HTTP/HTTPS from local network
    extraCommands = ''
      # Allow HTTP/HTTPS only from local network
      iptables -I INPUT -p tcp --dport 80 -s 192.168.1.0/24 -j ACCEPT
      iptables -I INPUT -p tcp --dport 443 -s 192.168.1.0/24 -j ACCEPT
      iptables -I INPUT -p tcp --dport 80 -j LOG --log-prefix "HTTP_BLOCKED: "
      iptables -I INPUT -p tcp --dport 443 -j LOG --log-prefix "HTTPS_BLOCKED: "
      iptables -I INPUT -p tcp --dport 80 -j DROP
      iptables -I INPUT -p tcp --dport 443 -j DROP
    '';
  };

  # System packages
  environment.systemPackages = with pkgs; [
    # For generating password hashes
    apacheHttpd # provides htpasswd command

    # SSL/TLS tools
    openssl

    # Network debugging
    curl
    wget
  ];

  # Log rotation for Traefik logs
  services.logrotate = {
    enable = true;
    settings = {
      "/var/log/traefik/*.log" = {
        frequency = "daily";
        rotate = 7;
        compress = true;
        delaycompress = true;
        missingok = true;
        notifempty = true;
        create = "644 traefik traefik";
        postrotate = ''
          systemctl reload traefik || true
        '';
      };
    };
  };

  # Create SSL directory and self-signed certificate for local development
  systemd.services.traefik-ssl-setup = {
    description = "Generate self-signed SSL certificate for Traefik";
    wantedBy = ["traefik.service"];
    before = ["traefik.service"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      SSL_DIR="/var/lib/traefik/ssl"
      mkdir -p "$SSL_DIR"

      if [ ! -f "$SSL_DIR/${hostname}.crt" ]; then
        echo "Generating self-signed SSL certificate..."
        ${pkgs.openssl}/bin/openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
          -keyout "$SSL_DIR/${hostname}.key" \
          -out "$SSL_DIR/${hostname}.crt" \
          -subj "/C=US/ST=Local/L=Local/O=${hostname}/CN=${fqdn}" \
          -extensions v3_ca \
          -config <(echo "[v3_ca]"; echo "subjectAltName=DNS:${fqdn},DNS:localhost,IP:${staticIP},IP:127.0.0.1")

        chown -R traefik:traefik "$SSL_DIR"
        chmod 600 "$SSL_DIR"/*.key
        chmod 644 "$SSL_DIR"/*.crt
        echo "SSL certificate generated successfully"
      fi
    '';
  };
}
