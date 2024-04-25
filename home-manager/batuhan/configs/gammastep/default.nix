# Screen dimmer
{
  pkgs,
  lib,
  ...
}: {
  services.gammastep = {
    enable = lib.mkOptionDefault true;
    package = pkgs.gammastep;
    latitude = "30.3";
    longitude = "-97.7";
    provider = "geoclue2";
    tray = true;
  };
}
