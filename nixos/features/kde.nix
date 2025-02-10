# NixOS: nixos/features/kde.nix
{
  pkgs,
  ...
}: {

  # Enable plasma
  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Exclude some unneeded packages
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
  ];

  # Include some Plasma project packages
  environment.systemPackages = with pkgs.kdePackages; [
    pkgs.unstable.kdePackages.marble    # Maps
    dragon    # Media player
    kmail     # Email client
    yakuake   # Dropdown terminal
  ];

}
