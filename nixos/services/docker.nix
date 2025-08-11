# nixos/services/docker.nix
# Enables docker containers
{
  config,
  pkgs,
  ...
}: {
  # Add rootless docker
  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };

  users.users.${config.myNixOS.userName}.extraGroups = ["docker"];
}
