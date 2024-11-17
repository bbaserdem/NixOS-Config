# PC system configuration file.
{
  inputs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../default.nix
    inputs.disko.nixosModules.disko
    ./disk-layout.nix
  ];

  # Set our name
  networking.hostName = "yertengri";

  # Module toggles
  myNixOS = {
    # Features
    bluetooth.enable = true;
    consolefont.enable = true;
    droidcam.enable = true;
    fonts.enable = true;
    gnome.enable = true;
    grub = {
      enable = true;
      flavor = "dark";
    };
    hyprland.enable = true;
    keymap.enable = true;
    matlab.enable = false;
    polkit.enable = true;
    sddm.enable = false;
    steam.enable = true;
    virtualization.enable = true;
    # Services
    services = {
      avahi.enable = true;
      cups.enable = true;
      earlyoom.enable = true;
      geoclue.enable = false;
      fingerprint.enable = false;
      mariadb.enable = true;
      media.enable = true;
      nm.enable = true;
      rasdaemon.enable = true;
      samba.enable = true;
      tlp.enable = false;
      udev.enable = true;
      udisks.enable = true;
    };
    # Enable default user generation
    defaultUser.enable = true;
    userName = "batuhan";
    userDesktop = "gnome";
  };

  # Secrets management
  sops = {
    defaultSopsFile = ./secrets.yaml;
    age = {
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      generateKey = false;
    };
    secrets = {
      crypt-data = {
        format = "binary";
        sopsFile = ./crypt_data.key;
        path = "/run/cryptsetup-keys.d/Yertengri_Data.key";
      };
      crypt-work = {
        format = "binary";
        sopsFile = ./crypt_work.key;
        path = "/run/cryptsetup-keys.d/Yertengri_Work.key";
      };
      "syncthing/key" = {
        mode = "0440";
        owner = config.myNixOS.userName;
        group = if config.myNixOS.services.syncthing.enable then "syncthing" else config.users.users.nobody.group;
      };
      "syncthing/cert" = {
        mode = "0440";
        owner = config.myNixOS.userName;
        group = if config.myNixOS.services.syncthing.enable then "syncthing" else config.users.users.nobody.group;
      };
    };
  };
}
