# nixos/services/firefly-iii.nix
# Firefly budgeting service
{config, ...}: {
  # Load our secrets
  sops.secrets = {
    "firefly-iii/key" = {
      owner = "firefly-iii";
    };
    "firefly-iii/db-password" = {
      owner = "firefly-iii";
    };
  };

  services = {
    firefly-iii = {
      enable = true;

      # Virtual host for nginx
      enableNginx = true;
      virtualHost = "localhost";

      # Add firefly-iii user to mysql group for socket access
      group = "mysql";

      # Settings for Firefly's .env vars
      settings = {
        APP_ENV = "local";
        APP_KEY_FILE = config.sops.secrets."firefly-iii/key".path;
        # Database connection
        DB_CONNECTION = "mysql";
        DB_HOST = "localhost";
        DB_PORT = 3306;
        DB_DATABASE = "firefly";
        DB_USERNAME = "firefly";
        DB_PASSWORD_FILE = config.sops.secrets."firefly-iii/db-password".path;
        DB_SOCKET = config.services.mysql.settings.mysqld.socket or "/run/mysqld/mysqld.sock";
        # Timezone
        TZ = "America/Chicago";
      };
    };

    # Configure nginx to listen on a given port
    nginx.virtualHosts.${config.services.firefly-iii.virtualHost} = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 8084;
        }
      ];
    };

    # MariaDB setup, assuming the same computer is the mariadb host
    mysql = {
      ensureDatabases = ["firefly"];
      ensureUsers = [
        {
          name = "firefly";
          ensurePermissions = {
            "firefly.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    # Setup Unix socket authentication for firefly user
    systemd.services.mysql.postStart = ''
      ${pkgs.mariadb}/bin/mysql -e "
        ALTER USER 'firefly'@'localhost' IDENTIFIED VIA unix_socket;
        FLUSH PRIVILEGES;
      " || true
    '';
  };
}
