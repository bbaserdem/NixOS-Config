# Desktop theming related things
{
  config,
  pkgs,
  ...
}: {

  # Set our cursor
  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    x11.enable = true;
    gtk.enable = true;
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

    # Cursor on gtk
    #cursorTheme = {
    #  name = "Bibata-Modern-Ice";
    #  package = pkgs.bibata-cursors;
    #};
    # Icons on gtk

    iconTheme = {
      name = "Qogir";
      package = pkgs.qogir-icon-theme;
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
      theme=catppuccin-mocha-sapphire
    '';
    "Kvantum/catppuccin-mocha-sapphire".source = 
      "${pkgs.catppuccin-sapphire-mocha-kvantum}/share/Kvantum/catppuccin-mocha-sapphire";
  };

  home.packages = with pkgs; [
    libsForQt5.qt5ct
    kdePackages.qt6ct 
    catppuccin-sapphire-mocha-kvantum
  ];
}
