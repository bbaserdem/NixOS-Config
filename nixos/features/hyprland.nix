# Hyprland user-space patching
{...}: {
  # Enables Hyprland as a session
  programs.hyprland = {
    enable = true;
    withUWSM = true; # LAunch with Universal Wayland Session Manager
    xwayland.enable = true;
  };

  # Hint electron apps to use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
