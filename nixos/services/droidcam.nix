# nixos/features/droidcam.nix
{
  config,
  pkgs,
  ...
}: {
  # Add loopback kernel module
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.kernelModules = [
    "v4l2loopback"
    "snd-aloop"
  ];

  # Enable droidcam modules
  programs.droidcam.enable = true;

  # enable android proper data tethering
  programs.adb.enable = true;

  # Open ports; might not be needed
  networking.firewall.allowedTCPPorts = [4747];
  networking.firewall.allowedUDPPorts = [4747];

  # Enable v4l2loopback GUI utils
  environment.systemPackages = with pkgs; [
    v4l-utils
  ];
}
