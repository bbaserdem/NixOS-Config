# NixOS: nixosModules/features/gnome.nix
{
  lib,
  config,
  inputs,
  outputs,
  myLib,
  pkgs,
  rootPath,
  ...
}: {
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    # Enable gnome login
    displayManager = {
      gdm.enable = true;
      # Enable auto login
      autoLogin = {
        enable = true;
        user = "batuhan";
      };
    };
    # Enable gnome
    desktopManager = {
      gnome.enable = true;
    };
  };
  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services = {
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
  };

  # Exclude some unneeded packages
  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-photos
      gnome-tour
      gedit
    ])
    ++ (with pkgs.gnome; [
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
    ]);

  # Make sure gnome-settings-daemon udev rules are enabled
  services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];
  # Profiler, needs to be system level installed
  services.sysprof.enable = true;

  # Enable extensions
  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    gnome.gnome-shell-extensions
  ];
  services.gnome.gnome-browser-connector.enable = true;
}
