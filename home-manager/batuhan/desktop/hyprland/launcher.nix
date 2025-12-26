# home-manager/batuhan/desktop/hyprland/launcher.nix
# Fuzzel; app launcher
{...}: {
  stylix.targets.fuzzel = {
    enable = true;
    colors.enable = true;
    fonts.enable = true;
    icons.enable = true;
    opacity.enable = true;
    polarity.enable = true;
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        dpi-aware = "auto";
        minimal-lines = false;
      };
    };
  };
}
