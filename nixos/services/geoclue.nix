# Configuring Geoclue
{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  # Enable
  services.geoclue2 = {
    enable = true;
    #appConfig = {
    #  firefox.isAllowed = true;
    #  qutebrowser.isAllowed = true;
    #  gammastep.isAllowed = true;
    #};
  };
}
