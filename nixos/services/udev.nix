# Configuring Udev

{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  # Enable Udev 
  services.udev.enable = true;
  # Enable qmk access
  hardware.keyboard.qmk.enable = true;
}
