# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{...}: {
  # You can import other NixOS modules here
  imports = [
    ./hardware-configuration.nix
    ../default.nix
  ];

  # Set our name
  networking.hostName = "umay";

  # Module toggles
  myNixOS = {
    # Features
    sddm.enable = false;
    gnome.enable = true;
    bluetooth.enable = false;
    virtualization.enable = false;
    consolefont.enable = true;
    fonts.enable = true;
    polkit.enable = true;
    grub = {
      enable = true;
      flavor = "bigSur";
    };
    keymap.enable = true;
    # Services
    services = {
      earlyoom.enable = false;
      samba.enable = true;
      mariadb.enable = true;
      nm.enable = true;
      avahi.enable = true;
      cups.enable = false;
      media.enable = true;
      tlp.enable = false;
      geoclue.enable = false;
      udev.enable = true;
      udisks.enable = true;
    };
    # Enable default user generation
    defaultUser.enable = true;
    userName = "batuhan";
    userDesktop = "gnome";
  };
}
