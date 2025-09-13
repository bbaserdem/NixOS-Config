# Main theming stuff
{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
lib.mkMerge [
  {
    stylix = {
      enable = true;
      autoEnable = false;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-soft.yaml";
      image = config.myHome.wallpaper.path;
      polarity = "dark";

      # Opacity options
      opacity = {
        applications = 1.0;
        desktop = 0.9;
        popups = 0.9;
        terminal = 0.9;
      };

      fonts = {
        monospace = {
          package = pkgs._3270font;
          name = "IBM 3270";
        };
        serif = {
          package = pkgs.caladea;
          name = "Caladea";
        };
        sansSerif = {
          package = pkgs.source-sans-pro;
          name = "Source Sans Pro";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };
    };
  }
  (lib.mkIf pkgs.stdenv.isLinux {
    # Icons
    stylix = {
      iconTheme = {
        enable = true;
        package = pkgs.qogir-icon-theme;
        dark = "Qogir-dark";
        light = "Qogir";
      };

      # Cursor
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
      };

      # Enable themeing systemwide
      targets = {
        gtk.enable = true;
        kde.enable = true;
        xresources.enable = true;
      };
    };
  })
]
