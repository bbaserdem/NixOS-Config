# Configuring neo4j
{config, ...}: {
  # Load our secrets
  sops.secrets = {
    "neo4j/private-key" = {};
    "neo4j/public-certificate" = {};
  };

  services.neo4j = {
    enable = true;
    # Enable shell access
    # shell.enable = true;

    # Turn off login, we are only local
    extraServerConfig = ''
      dbms.security.auth_enabled=false
    '';

    # Define the SSL policy
    # ssl.policies.local-policy = {
    #   clientAuth = "REQUIRE";
    #   publicCertificate = config.sops.secrets."neo4j/public-certificate".path;
    #   privateKey = config.sops.secrets."neo4j/private-key".path;
    # };

    # Interfaces
    http = {
      enable = true;
      listenAddress = "127.0.0.1:7474";
    };
    https = {
      enable = false;
      listenAddress = "127.0.0.1:7473";
    };
    bolt = {
      enable = true;
      listenAddress = "127.0.0.1:7687";
      tlsLevel = "DISABLED";
      #tlsLevel = "REQUIRED";
      #sslPolicy = "local-policy";
    };
  };
}
