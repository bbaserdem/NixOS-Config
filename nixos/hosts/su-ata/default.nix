# PC system configuration file.
{
  inputs,
  outputs,
  config,
  lib,
  host,
  ...
}: let
  user = "batuhan";
in {
  imports = [
    ../default.nix
    ./hardware-configuration.nix
    inputs.disko.nixosModules.disko
    ./disk-layout.nix
    # Do user as home-manager module
    inputs.home-manager.nixosModules.home-manager
    # Configuration modules
    ./network.nix
  ];

  # Set our name, and our server settings
  networking.hostName = host;

  # Module toggles
  myNixOS = {
    # We will have a desktop for now, but in general we won't have this
    userDesktop = "gnome";
    dispalManager = {
      enable = true;
      name = "gdm";
    };
    gnome.enable = true;

    # Features
    consolefont.enable = true;
    fonts.enable = true;
    grub = {
      enable = true;
      flavor = "orange";
    };
    keymap.enable = true;
    polkit.enable = true;

    # Services
    services = {
      avahi.enable = true;
      docker.enable = true;
      jupyter.enable = true;
      rasdaemon.enable = true;
      samba.enable = true;
      ssh.enable = true;
      syncthing.enable = true;
      udev.enable = true;
    };
  };

  # Making syncthing network available to outside
  services.syncthing.guiAddress = lib.mkForce "0.0.0.0:8384";

  # Making jupyter available from network
  myNixOS.services.jupyter.ip = lib.mkForce "0.0.0.0";

  # Use home-manager as nixos module
  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users = {
      "${user}" = ../../../home-manager/${user}/${host}.nix;
    };
  };

  # Secrets management
  sops.secrets = {
    "syncthing/key" = {
      sopsFile = ./secrets.yaml;
      mode = "0440";
      owner = config.myNixOS.userName;
      group =
        if config.myNixOS.services.syncthing.enable
        then "syncthing"
        else config.users.users.nobody.group;
    };
    "syncthing/cert" = {
      sopsFile = ./secrets.yaml;
      mode = "0440";
      owner = config.myNixOS.userName;
      group =
        if config.myNixOS.services.syncthing.enable
        then "syncthing"
        else config.users.users.nobody.group;
    };
  };
}
