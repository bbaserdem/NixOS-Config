# nixos/features/droidcam.nix
{
  lib,
  config,
  inputs,
  outputs,
  myLib,
  pkgs,
  rootPath,
  ...
}: {
  # Enable droidcam modules
  programs.droidcam.enable = true;

  # enable android proper data tethering
  programs.adb.enable = true;

  # Open ports; might not be needed
  networking.firewall.allowedTCPPorts = [4747];
  networking.firewall.allowedUDPPorts = [4747];
}
