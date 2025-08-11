# nixos/services/docker.nix
# Enables docker containers
{
  config,
  pkgs,
  ...
}: {
  # Add rootless docker
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings = {
        dns_enabled = true;
        driver = "bridge";
      };
    };
  };

  users.users.${config.myNixOS.userName}.extraGroups = ["docker"];
}
