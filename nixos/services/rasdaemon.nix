# Configuring Tools for Laptop Power (TLP)
{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  # Enable TLP
  hardware.rasdaemon = {
    enable = true;
  };
}
