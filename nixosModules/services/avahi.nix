# Configuring discovery 

{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };
}
