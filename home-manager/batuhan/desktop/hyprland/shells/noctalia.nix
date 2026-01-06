# home-manager/batuhan/desktop/hyprland/shells/noctalia.nix
# Noctalia shell
{
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  # Override the targets to hyprland
  systemd.user.services.noctalia-shell = {
    Unit = {
      PartOf = lib.mkForce ["wayland-session@Hyprland.target"];
      After = lib.mkForce ["wayland-session@Hyprland.target"];
    };
    Install.WantedBy = lib.mkForce ["wayland-session@Hyprland.target"];
  };

  # Configure noctalia shell
  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;
    settings = {};
  };
}
