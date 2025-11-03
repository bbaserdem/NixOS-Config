# nixos/services/firefly-iii.nix
# Firefly budgeting service
{
  config,
  pkgs,
  ...
}: {
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

      # Add firefly-iii user to nginx for access to php-fpm socket
      group = "nginx";

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
  };

  # Systemd service to set the password
  systemd.services.firefly-db-setup = {
    description = "Setup Firefly III database password";
    after = ["mysql.service"];
    requires = ["mysql.service"];
    before = ["firefly-iii-setup.service"];
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      LoadCredential = "db-password:${config.sops.secrets."firefly-iii/db-password".path}";
    };

    script = ''
      # Wait for MySQL to be ready
      until ${pkgs.mariadb}/bin/mysqladmin ping --silent; do
        sleep 1
      done

      # Read password and set it
      PASSWORD=$(cat "$CREDENTIALS_DIRECTORY/db-password")
      ${pkgs.mariadb}/bin/mysql -e "ALTER USER 'firefly'@'localhost' IDENTIFIED BY '$PASSWORD'; FLUSH PRIVILEGES;"
    '';
  };
}
