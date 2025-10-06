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
      "su-ata" = {
        user = "batuhan";
        hostname = "su-ata";
        identitiesOnly = true;
        serverAliveInterval = 60;
        serverAliveCountMax = 3;
        extraOptions.IdentityFile = "~/.ssh/id_ed25519_SU-ATA";
        forwardX11 = true;
        forwardX11Trusted = true;
      };
    };
  };
}
