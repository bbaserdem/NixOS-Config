# Desktop theming related things
{
  config,
  pkgs,
  ...
}: let
  catppuccin-kvantum = pkgs.catppuccin-kvantum.override {
    accent = "Mauve";
    variant = "Latte";
  };
in {
  # Set our cursor
  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    x11.enable = true;
    gtk.enable = true;
  };
  # Setup our gtk options
  gtk = {
    enable = true;
    # No theme options yet
    # Icons on gtk
    iconTheme = {
      name = "Qogir";
      package = pkgs.qogir-icon-theme;
    };
    # Dark theming
    gtk3.extraConfig.gtk-application-prefer-dark-theme = "0";
    gtk4.extraConfig.gtk-application-prefer-dark-theme = "0";
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
      theme=Catppuccin-Latte-Mauve
    '';
    "Kvantum/Catppuccin-Latte-Mauve".source = "${catppuccin-kvantum}/share/Kvantum/Catppuccin-Latte-Mauve";
  };
  home.packages = [
    catppuccin-kvantum
  ];
}
