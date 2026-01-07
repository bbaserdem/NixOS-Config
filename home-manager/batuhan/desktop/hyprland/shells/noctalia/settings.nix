# home-manager/batuhan/desktop/hyprland/shells/noctalia/settings.nix
# Settings block for noctalia shell
{
  lib,
  config,
  ...
}: {
  config = lib.mkIf (config.userConfig.hyprland.shell == "noctalia") {
    programs.noctalia-shell.settings = {};
  };
}
