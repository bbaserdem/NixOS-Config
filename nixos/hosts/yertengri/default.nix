# PC system configuration file.
{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../default.nix
    inputs.disko.nixosModules.disko
    ./disk-layout.nix
    # Do joey as home-manager module
    inputs.home-manager.nixosModules.home-manager
  ];

  # Set our name
  networking.hostName = "yertengri";

  # Weird fix for plasma + gnome
  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.kdePackages.ksshaskpass.out}/bin/ksshaskpass";

  # Module toggles
  myNixOS = {
    # Enable default user generation
    defaultUser.enable = true;
    userName = "batuhan";
    userDesktop = "plasma";

    # Desktop
    displayManager = {
      enable = true;
      name = "sddm";
    };
    gnome.enable = true;
    hyprland.enable = true;
    kde.enable = true;

    # Features
    bluetooth.enable = true;
    consolefont.enable = true;
    droidcam.enable = true;
    fonts.enable = true;
    gaming.enable = true;
    grub = {
      enable = true;
      flavor = "dark";
    };
    keymap.enable = true;
    matlab.enable = false;
    polkit.enable = true;
    virtualization.enable = true;

    # Services
    services = {
      avahi.enable = true;
      cups.enable = true;
      earlyoom.enable = true;
      geoclue.enable = false;
      fingerprint.enable = false;
      kdeconnect.enable = true;
      mariadb.enable = true;
      media.enable = true;
      nm.enable = true;
      paperless.enable = true;
      rasdaemon.enable = true;
      samba.enable = true;
      syncthing.enable = true;
      tlp.enable = false;
      udev.enable = true;
      udisks.enable = true;
    };
  };

  # Joey's account
  users.users.joeysaur = {
    # Account setup for login
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."joeysaur/password-hash".path;
    description = "Joseph Hirsh";
    shell = pkgs.zsh;
  };
  #home-manager = {
  #  extraSpecialArgs = { inherit inputs outputs; };
  #  users = {
  #    joeysaur = ../../../home-manager/joeysaur/default.nix;
  #  };
  #};

  # Secrets management
  sops.secrets = {
    crypt-data = {
      sopsFile = ./crypt_data.key;
      format = "binary";
      path = "/run/cryptsetup-keys.d/Yertengri_Data.key";
    };
    crypt-work = {
      sopsFile = ./crypt_work.key;
      format = "binary";
      path = "/run/cryptsetup-keys.d/Yertengri_Work.key";
    };
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
    "joeysaur/cryptkey/qwerty" = {
      sopsFile = ./secrets.yaml;
    };
    "joeysaur/cryptkey/dvorak" = {
      sopsFile = ./secrets.yaml;
    };
  };
}
