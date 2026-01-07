# home-manager/batuhan/desktop/hyprland/shells/default.nix
# Chooses the default shell implementation, this way I can switch easily.
{lib, ...}: {
  options.userConfig.hyprland.shell = lib.mkOption {
    type = lib.types.nullOr (lib.types.enum ["hyprpanel" "noctalia"]);
    default = null;
    description = "The shell to use for Hyprland (hyprpanel or noctalia)";
  };

  imports = [
    ./hyprpanel
    ./noctalia
  ];

  # Set preferred shell
  config.userConfig.hyprland.shell = "noctalia";
}
