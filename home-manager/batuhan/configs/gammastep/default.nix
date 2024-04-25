# Screen dimmer
{
  pkgs,
  ...
}: {
  services.gammastep = {
    enable = true;
    package = pkgs.gammastep;
    latitude = "30.3";
    longtitude = "-97.7";
    provider = "geoclue2";
    tray = true;
  };
}
