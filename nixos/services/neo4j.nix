# Configuring neo4j
{config, ...}: {
  services.neo4j = {
    enable = true;
    # Enable shell access
    shell.enable = true;

    # Turn off login, we are only local
    extraServerConfig = ''
      dbms.security.auth_enabled=false
    '';

    # Define the SSL policy
    ssl.policies.local-policy = {
      publicCertificate = config.sops.secrets."neo4j/public-certificate".path;
      privateKey = config.sops.secrets."neo4j/private-key".path;
    };

    # Interfaces
    https = {
      enable = true;
      listenAddress = "localhost:7473";
    };
    http = {
      enable = true;
      listenAddress = "localhost:7474";
    };
    bolt = {
      enable = true;
      listenAddress = "localhost:7687";
      tlsLevel = "REQUIRED";
      sslPolicy = "local-policy";
    };
  };
}
