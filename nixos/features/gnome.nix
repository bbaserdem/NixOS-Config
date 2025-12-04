# NixOS: nixosModules/features/gnome.nix
{pkgs, ...}: {
  services = {
    # Enable gnome
    desktopManager.gnome.enable = true;

    # Add udev packages
    udev.packages = with pkgs; [
      gnome-settings-daemon
    ];

    # Profiler, needs to be system level installed
    sysprof.enable = true;
    gnome.gnome-browser-connector.enable = true;
  };

  # Exclude some unneeded packages
  environment.gnome.excludePackages = with pkgs; [
    gnome-photos
    gnome-tour
    gedit
    cheese
    gnome-music
    gnome-terminal
    epiphany
    geary
    evince
    gnome-characters
    totem
    tali
    iagno
    hitori
    atomix
  ];

  # Enable extensions
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnome-shell-extensions
  ];
}
