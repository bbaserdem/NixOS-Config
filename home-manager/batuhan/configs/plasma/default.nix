# Configuring plasma
{
  pkgs,
  ...
}: {

  # Enable KDE connect
  services.kdeconnect = {
    enable = true;
    indicator = true;
    package = pkgs.kdePackages.kdeconnect-kde;
  };

}
