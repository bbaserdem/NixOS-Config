# Configuring SSH servers
{
  pkgs,
  config,
  ...
}: {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      # Servers to connect to
      ellipsis = {
        user = "batu";
        hostname = "ellipsis.cshl.edu";
        identitiesOnly = true;
        extraOptions = {
          HostKeyAlgorithms = "ssh-rsa";
          IdentityFile = "~/.ssh/id_rsa_ELLIPSIS";
          PubkeyAcceptedAlgorithms = "+ssh-rsa";
          PubkeyAcceptedKeyTypes = "+ssh-rsa";
        };
      };
    };
  };
}
