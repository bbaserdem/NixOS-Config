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
      firefox.enable = true;
      gtk.enable = true;
      hyprland = {
        enable = true;
        hyprpaper.enable = true;
      };
      hyprlock.enable = true;
      hyprpaper.enable = true;
      kitty.enable = true;
      lazygit.enable = true;
      tmux.enable = true;
      vencord.enable = true;
      xresources.enable = true;
    };
  };

  # Setup our gtk options
  gtk = {
    enable = true;
    # Theming
    theme = {
      name = "Catppuccin-Mocha-Compact-Sapphire-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = ["sapphire"];
        size = "compact";
        tweaks = ["rimless" "black"];
        variant = "mocha";
      };
    };
    # Dark theming
    gtk3.extraConfig.gtk-application-prefer-dark-theme = "1";
    gtk4.extraConfig.gtk-application-prefer-dark-theme = "1";
  };
  # Symlinks needed for gtk4
  xdg.configFile = {
    "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  };

  # Setup QT options
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };
  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=Catppuccin-Mocha-Sapphire
    '';
    "Kvantum/Catppuccin-Mocha-Sapphire".source = "${catppuccin-kvantum}/share/Kvantum/Catppuccin-Mocha-Sapphire";
  };
  home.packages = [
    catppuccin-kvantum
  ];
}
