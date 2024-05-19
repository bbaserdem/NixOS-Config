# Hyprland user-space patching
{
  inputs,
  pkgs,
  ...
}: {
  # Enables Hyprland as a session
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # From flake inputs, but not necessary
    # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
  # Move hardware OpenGL to unstable to match hyprland flake version
  # hardware.opengl = {
  # package = pkgs.unstable.mesa.drivers;
  # Enable 32 bit support
  # driSupport32Bit = true;
  # package32 = pkgs.unstable.pkgsi686Linux.mesa.drivers;
  # };
}
