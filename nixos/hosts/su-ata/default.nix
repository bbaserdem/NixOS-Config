# PC system configuration file.
{
  inputs,
  outputs,
  config,
  lib,
  host,
  arch,
  ...
}: let
  user = "batuhan";
in {
  imports = [
    ./hardware-configuration.nix
    inputs.disko.nixosModules.disko
    ./disk-layout.nix
    # Do user as home-manager module
    inputs.home-manager.nixosModules.home-manager
    # Configuration modules
    ./network.nix
    ./cuda.nix
  ];

  # Set our name, and our server settings
  networking.hostName = host;

  # Disable sleep
  systemd.sleep.extraConfig = ''
    [Sleep]
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  # Module toggles
  myNixOS = {
    # We will have a desktop for now, but in general we won't have this
    userDesktop = "gnome";
    displayManager = {
      enable = true;
      name = "gdm";
    };
    gnome.enable = true;

    # Features
    consolefont.enable = true;
    fonts.enable = true;
    keymap.enable = true;
    polkit.enable = true;

    # Services
    services = {
      avahi.enable = true;
      docker.enable = true;
      jupyterlab.enable = false;
      rasdaemon.enable = true;
      samba.enable = true;
      ssh.enable = true;
      syncthing.enable = true;
      udev.enable = true;
    };

    # Disables
    grub.enable = lib.mkForce false;
  };

  # Syncthing folders
  services.syncthing.settings.folders = {
    media.enable = false;
    sort.enable = false;
    work.enable = false;
    skyfi.enable = true;
    phone.enable = false;
  };

  # SECURITY TODO: When Traefik is setup, change back to localhost
  # Making syncthing network available to outside
  services.syncthing.guiAddress = lib.mkForce "0.0.0.0:8384"; # TODO: Change to "127.0.0.1:8384" with Traefik

  # SECURITY TODO: When Traefik is setup, secure these settings
  # Making jupyter available from network
  myNixOS.services.jupyterlab.ip = lib.mkForce "0.0.0.0"; # TODO: Change to "127.0.0.1" with Traefik
  myNixOS.services.jupyterlab.notebookConfig = lib.mkForce ''
    # JupyterLab configuration for remote access
    c.ServerApp.allow_remote_access = True # TODO: Change to False with Traefik
    c.ServerApp.disable_check_xsrf = True  # TODO: Consider enabling XSRF with Traefik auth
    c.ServerApp.open_browser = False

    # Resource limits
    c.ServerApp.max_buffer_size = 2147483648 # 2GB
    c.ServerApp.max_body_size = 2147483648   # 2GB

    # Kernel management
    c.MappingKernelManager.cull_idle_timeout = 7200    # 2 hours
    c.MappingKernelManager.cull_interval = 300         # Check every 5 minutes
    c.MappingKernelManager.cull_connected = False      # Don't cull connected
  '';

  # Use home-manager as nixos module
  home-manager = {
    extraSpecialArgs = {inherit inputs outputs host user arch;};
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
