# Configuring Geoclue
{
  config,
  pkgs,
  lib,
  ...
}: {
  # Enable
  services.geoclue2 = {
    enable = true;
    #appConfig = {
    #  firefox.isAllowed = true;
    #  qutebrowser.isAllowed = true;
    #  gammastep.isAllowed = true;
    #};
  };

  # Import the SOPS secrets
  sops.secrets."google/geoApiUrl" = {
    mode = "0444";
    path = "/etc/geoclue/conf.d/99-google-api.conf";
  };
}
