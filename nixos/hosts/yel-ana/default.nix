# Laptop system configuration file.
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  system,
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
    # Features
    bluetooth.enable = true;
    consolefont.enable = true;
    droidcam.enable = true;
    fonts.enable = true;
    gnome.enable = true;
    grub = {
      enable = true;
      flavor = "bigSur";
    };
    hyprland.enable = true;
    keymap.enable = true;
    matlab.enable = false;
    polkit.enable = true;
    sddm.enable = false;
    steam.enable = false;
    virtualization.enable = true;
    # Services
    services = {
      avahi.enable = true;
      cups.enable = true;
      earlyoom.enable = true;
      geoclue.enable = true;
      fingerprint.enable = true;
      mariadb.enable = true;
      media.enable = true;
      nm.enable = true;
      rasdaemon.enable = true;
      samba.enable = true;
      tlp.enable = true;
      udev.enable = true;
      udisks.enable = true;
    };
    # Enable default user generation
    default-user.enable = true;
    userName = "batuhan";
    userDesktop = "gnome";
  };

  # Secrets management
  sops.defaultSopsFile = ./secrets.yaml;
  sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  sops.secrets = {
    crypt-data = {
      format = "binary";
      sopsFile = ./crypt-data.key;
      path = "/run/cryptsetup-keys.d/Yel-Ana_Data.key";
    };
  };
}
