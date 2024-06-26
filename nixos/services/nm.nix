# Configuring network manager
{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  # Enable network manager
  networking.networkmanager.enable = true;
  # Add default user to networkmanager
  users.extraGroups.networkmanager.members = [
    config.myNixOS.userName
  ];
  # Enable timezoned
  services.automatic-timezoned.enable = true;
}
