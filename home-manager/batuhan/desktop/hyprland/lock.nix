# home-manager/batuhan/desktop/hyprland/lock.nix
# Hyprlock config
{...}: {
  stylix.targets.hyprlock = {
    enable = true;
    colors.enable = true;
    image.enable = true;
    useWallpaper = true;
  };

  programs.hyprlock = {
    # Enable hyprpanel
    enable = true;
    settings = {
      general = {
        hide_cursor = false;
        ignore_empty_input = true;
      };
      animation- = {
        enabled = true;
        fade_in = {
          duration = 300;
          bezier = "easeOutQuint";
        };
        fade_out = {
          duration = 300;
          bezier = "easeOutQuint";
        };
      };
      background = {
        monitor = "";
        blur_passes = 3;
        blur_size = 8;
      };
      input-field = {
        monitor = "";
        size = "20%, 5%";
        outline_thickness = 3;
        fade_on_empty = false;
        rounding = 15;

        font_family = "Monospace";
        placeholder_text = "Input password...";
      };
    };
  };
}
