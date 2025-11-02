# nixos/services/firefly-iii.nix
# Firefly budgeting service
{...}: {
  services = {
    firefly-iii = {
      enable = true;
      settings = {
        #APP_ENV = "production";
        #APP_KEY_FILE = "/var/secrets/firefly-iii-app-key.txt";
        #SITE_OWNER = "mail@example.com";
        #DB_CONNECTION = "mysql";
        #DB_HOST = "db";
        #DB_PORT = 3306;
        #DB_DATABASE = "firefly";
        #DB_USERNAME = "firefly";
        #DB_PASSWORD_FILE = "/var/secrets/firefly-iii-mysql-password.txt";
      };
      enableNginx = true;
    };

    firefly-iii-data-importer = {
      enable = true;
      settings = {
        APP_ENV = "local";
        LOG_CHANNEL = "syslog";
        FIREFLY_III_ACCESS_TOKEN = "/var/secrets/firefly-iii-access-token.txt";
      };
    };
  };
}
