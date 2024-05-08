# Screen dimmer
{
  pkgs,
  lib,
  ...
}: {
  services.gammastep = {
    enable = lib.mkDefault true;
    package = pkgs.gammastep;
    latitude = "30.3";
    longitude = "-97.7";
    provider = "manual";
    tray = true;
  };
}
