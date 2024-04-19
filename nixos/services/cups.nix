# Configuring printing services

{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  services.printing = {
    enable = true;
    # Enable printer sharing
    listenAddresses = [ "*:631" ];
    allowFrom = [ "all" ];
    browsing = true;
    defaultShared = true;
    # For some reason, this isn't working
    #openFirewall = true;
  };
}

