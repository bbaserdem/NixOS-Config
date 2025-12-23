# Hyprland user-space patching
{pkgs, ...}: {
  # Enables Hyprland as a session
  programs = {
    hyprland = {
      enable = true;
      withUWSM = true; # Launch with Universal Wayland Session Manager
      xwayland.enable = true;
    };
    hyprlock.enable = true;
    uwsm.enable = true;
  };

  # Enable Qt configuration for proper plugin discovery
  qt.enable = true;

  # Install Kirigami system-wide for Qt plugin discovery
  environment.systemPackages = with pkgs; [
    kdePackages.kirigami
  ];

  # Hint electron apps to use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
