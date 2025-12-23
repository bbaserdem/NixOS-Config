# Hyprland user-space patching
{...}: {
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

  # Hint electron apps to use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
