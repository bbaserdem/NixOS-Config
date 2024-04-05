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
  rootPath,
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
    #sddm.enable = false;
    gnome.enable = true;
    # Bundles
    bundles = {
      archives.enable = true;
      utils.enable = true;
    };
    # Services
    services = {
      satisfactory.enable = false;
    };
    # Enable default user generation
    default-user.enable = true;
    userName = "batuhan";
    userDesktop = "gnome";
  };

  # Set our name 
  networking.hostName = "umay";

  # Manually enable these for now 
  # Packages to install 
  #environment.systemPackages = with pkgs; [
  #  neovim
  #  wget
  #  git
  #  home-manager
  #  btop
  #];
}
