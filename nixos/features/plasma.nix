# NixOS: nixos/features/kde.nix
{pkgs, ...}: {

  # Enable plasma
  #services.desktopManager.plasma6.enable = true;
  services.xserver = {
    enable = true;
    desktopManager.plasma5.enable = true;
  };

  # Exclude some unneeded packages
  #environment.plasma6.excludePackages = with pkgs.kdePackages; [
  #  elisa
  #];
  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
  ];
}
