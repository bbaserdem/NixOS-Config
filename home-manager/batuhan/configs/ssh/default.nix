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
        HostKeyAlgorithms = "ssh-rsa";
      };
    };
  };
}
