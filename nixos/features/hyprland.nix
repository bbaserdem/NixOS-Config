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
}
