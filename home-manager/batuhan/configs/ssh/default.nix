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
      "github.com" = {
        user = "git";
        hostname = "github.com";
        identitiesOnly = true;
        extraOptions.IdentityFile = "~/.ssh/id_ed25519_GITHUB";
      };
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
