# Laptop system configuration file.
{
  inputs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../default.nix
  ];

  # Set our name
  networking.hostName = "yel-ana";

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
    gnome.enable = false;
    hyprland.enable = true;
    kde.enable = true;
    # Features
    bluetooth.enable = true;
    consolefont.enable = true;
    fonts.enable = true;
    gaming.enable = false;
    grub = {
      enable = true;
      flavor = "bigSur";
    };
    keymap.enable = true;
    matlab.enable = false;
    obs.enable = true;
    polkit.enable = true;
    virtualization.enable = true;
    # Services
    services = {
      avahi.enable = true;
      cups.enable = true;
      docker.enable = true;
      droidcam.enable = true;
      earlyoom.enable = true;
      geoclue.enable = true;
      fingerprint.enable = true;
      fwupd.enable = true;
      kdeconnect.enable = true;
      mariadb.enable = true;
      media.enable = true;
      nm.enable = true;
      rasdaemon.enable = true;
      samba.enable = true;
      syncthing.enable = true;
      tlp.enable = true;
      udev.enable = true;
      udisks.enable = true;
      vpn.enable = true;
    };
  };

  # Secrets management
  sops.secrets = {
    crypt-data = {
      sopsFile = ./crypt-data.key;
      format = "binary";
      path = "/run/cryptsetup-keys.d/Yel-Ana_Data.key";
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
    "batuhan/password-hash" = {
      neededForUsers = true;
    };
  };
}
