# Configuring bluetooth
{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.blueman.enable = true;
}
