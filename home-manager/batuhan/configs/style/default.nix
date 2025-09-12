# Main theming stuff
{
  inputs,
  pkgs,
  config,
  ...
}: {
  # Load stylix
  imports = [
    inputs.stylix.homeManagerModules.stylix
  ];

  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-soft.yaml";
    image = config.myHome.wallpaper.path;
    polarity = "dark";

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
      terminal = 0.9;
    };

    # Enable themeing systemwide
    targets = {
      gtk.enable = true;
      kde.enable = true;
      xresources.enable = true;
      # Apps
      lazygit.enable = true;
      kitty.enable = true;
      tmux.enable = true;
    };
  };
}
