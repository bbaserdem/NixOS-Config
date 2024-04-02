# NixOS: hosts/umay/configuration.nix

{ config, pkgs, lib, inputs, outputs, system, myLib, ... }:

{
  imports =
    [
      outputs.nixosModules.default
      ./hardware-configuration.nix
    ];

  # Boot options
  boot.loader.grub = {
    enable = true;
    useOSProber = false;
  };

  # Modules options
  myNixOS = {
    #bundles.general-desktop.enable = true;
    #bundles.users.enable = true;
    bundles.home-manager.enable = true;
    #power-management.enable = true;
    #sops.enable = false;

    #virtualization.enable = lib.mkDefault true;

    #sharedSettings.hyprland.enable = true;

    home-users = {
      "batuhan" = {
        userConfig = ./home.nix;
        userSettings = {
          extraGroups = ["wheel" "docker" "networkmanager"];
        };
      };
    };
  };

  networking.hostName = "umay";
    
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

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    home-manager
    btop
  ];

}
