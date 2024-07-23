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
  sops.secrets.google-url = {
    format = "yaml";
    sopsFile = ../hosts/secrets.yaml;
    mode = "0444";
    path = "/etc/geoclue/conf.d/99-google-api.conf";
  };
}
