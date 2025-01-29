# NixOS: nixos/features/kde.nix
{pkgs, ...}: {

  # Enable plasma
  services.xserver = {
    enable = true;
    desktopManager.plasma6.enable = true;
  };

  # Exclude some unneeded packages
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
  ];
}
