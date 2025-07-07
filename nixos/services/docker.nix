# nixos/services/docker.nix
# Enables docker containers
{
  config,
  pkgs,
  ...
}: {
  # Add rootless docker
  virtualisation.docker = {
    # Disable system wide docker
    enable = false;
    # Enable rootless docker instances
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  users.users.${config.myNixOS.userName}.extraGroups = ["docker"];
}
