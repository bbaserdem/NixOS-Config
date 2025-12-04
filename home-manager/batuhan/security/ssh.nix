# Configuring SSH servers
{
  pkgs,
  config,
  ...
}: {
  programs.ssh = {
    enable = true;
    # TODO: Remove this after migration
    enableDefaultConfig = false;
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
      "od-ata" = {
        user = "batuhan";
        hostname = "od-ata";
        identitiesOnly = true;
        extraOptions.IdentityFile = "~/.ssh/id_ed25519_OD-ATA";
      };
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "${config.home.homeDirectory}/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "${config.home.homeDirectory}/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
    };
  };
}
