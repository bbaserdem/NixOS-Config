# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  myLib,
  lib,
  config,
  pkgs,
  system,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    ./hardware-configuration.nix

    # Modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd
  ];

  # My module toggles
  myNixOS = {
    # Features 
    sddm.enable = false;
    # Bundles
    bundles = {
      archives.enable = true;
    };
    # Services
    services = {
      satisfactory.enable = false;
    };
  };

  # Set our name 
  networking.hostName = "umay";

  users.users = {
    batuhan = {
      initialPassword = "12345";
      isNormalUser = true;
      extraGroups = ["wheel" "docker" "networkmanager"];
    };
  };

  # Manually enable these for now 

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Enable gnome
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "batuhan";
  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
  # Packages to install 
  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    home-manager
    btop
  ];
}
