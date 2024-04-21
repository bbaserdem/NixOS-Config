# Desktop theming related things
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  myLib,
  rootPath,
  ...
}: let
  catppuccin-kvantum = pkgs.unstable.catppuccin-kvantum.override {
    accent = "Sapphire";
    variant = "Mocha";
  };
in {
  # Setup our gtk options
  gtk = {
    enable = true;
    # Theming
    theme = {
      name = "Catppuccin-Mocha-Compact-Sapphire-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "sapphire" ];
        size = "compact";
        tweaks = [ "rimless" "black" ];
        variant = "mocha";
      };
    };
    # Cursor on gtk
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };
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
    platformTheme = "qt5ct";
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
