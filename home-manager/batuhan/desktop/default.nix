# List of desktop integration modules
{
  pkgs,
  config,
  ...
}: {
  # Some app modules
  imports = [
    # ./gnome.nix
    ./hyprland
    ./keyboard.nix
    ./xdg-paths.nix
  ];

  stylix.targets = {
    gtk = {
      enable = true;
      flatpakSupport.enable = true;
    };
    # kde = { enable = true; };
    qt = {
      enable = true;
      platform = "qtct";
    };
  };

  # Configure qtct settings
  # Right now, pulling these manually from stylix.
  # Plasma sets qt.style to 'kde', and if it's set to qtct it breaks KDE
  # Stylix is only compatible with qtct, and won't apply qtct config w/out setting the style
  # qt = let
  #   qtctSettings = {
  #     Appearance = {
  #       custom_palette = true;
  #       standard_dialogs = "default";
  #       style = "breeze";
  #       icon_theme = config.stylix.icons.dark;
  #     };
  #     Fonts = {
  #       fixed = ''"${config.stylix.fonts.monospace.name},${toString config.stylix.fonts.sizes.applications}"'';
  #       general = ''"${config.stylix.fonts.sansSerif.name},${toString config.stylix.fonts.sizes.applications}"'';
  #     };
  #   };
  # in {
  #   qt6ctSettings = qtctSettings;
  #   qt5ctSettings = qtctSettings;
  # };

  # Enable autostarting stuff
  xdg.autostart.enable = true;

  # Include QT themes
  home.packages = with pkgs; [
    libsForQt5.qt5ct
    kdePackages.qt6ct
    kdePackages.breeze
  ];
}
