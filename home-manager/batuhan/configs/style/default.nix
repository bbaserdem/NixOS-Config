# Main theming stuff
{
  config,
  pkgs,
  ...
}: let
  catppuccin-kvantum = pkgs.catppuccin-kvantum.override {
    accent = "sapphire";
    variant = "mocha";
  };
in {

  stylix = {

    enable = true;
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-soft.yaml";

    # System fonts
    fonts = {
      serif = {
        package = pkgs.caladea;
        name = "Caladea";
      };
      sansSerif = {
        package = pkgs.source-sans-pro;
        name = "Source Sans Pro";
      };
      monospace = {
        package = pkgs._3270font;
        name = "IBM 3270";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };

    # Cursor
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };

    # Icons
    iconTheme = {
      enable = true;
      package = pkgs.qogir-icon-theme;
      dark = "Qogir-dark";
      light = "Qogir";
    };

    # Opacity options
    opacity = {
      applications = 1.0;
      desktop = 0.9;
      popups = 0.9;
      terminal = 0.85;
    };

    # App enables
    targets = {
      btop.enable = true;
      firefox = {
        enable = true;
        #firefoxGnomeTheme.enable = true;
        #profileNames = [];
      };
      fzf.enable = true;
      gnome.enable = true;
      gnome-text-editor.enable = true;
      gtk.enable = true;
      hyprland = {
        enable = true;
        hyprpaper.enable = true;
      };
      hyprlock.enable = true;
      hyprpaper.enable = true;
      kde.enable = true;
      kitty.enable = true;
      lazygit.enable = true;
      #nixcord.enable = true;
      tmux.enable = true;
      #vencord.enable = true;
      xresources.enable = true;
      zathura.enable = true;
    };
  };
}
