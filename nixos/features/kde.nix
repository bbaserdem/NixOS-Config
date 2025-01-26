# NixOS: nixos/features/kde.nix
{pkgs, ...}: {

  # Enable sddm
  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Enable plasma
  services.desktopManager.plasma6.enable = true;

  # Exclude some unneeded packages
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
  ];
}
