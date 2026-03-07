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
    qt = {
      enable = true;
      platform = "qtct";
      standardDialogs = "default";
    };
    # KDE and qt are not mutually compatible in stylix, but trying anyway
    kde = {enable = true;};
  };

  # Enable autostarting stuff
  xdg.autostart.enable = true;

  # Include QT themes
  home.packages = with pkgs; [
    libsForQt5.qt5ct
    kdePackages.qt6ct
    kdePackages.breeze
  ];
}
