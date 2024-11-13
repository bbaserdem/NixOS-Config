# PC system configuration file.
{
  inputs,
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
      geoclue.enable = true;
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
      path = "/run/cryptsetup-keys.d/Yertengri_Data.key";
    };
    crypt-work = {
      format = "binary";
      sopsFile = ./crypt-work.key;
      path = "/run/cryptsetup-keys.d/Yertengri_Work.key";
    };
  };
}
