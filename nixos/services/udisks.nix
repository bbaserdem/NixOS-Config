# Configuring Udisks
{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  # Enable Udisks
  services.udisks2.enable = true;
}
