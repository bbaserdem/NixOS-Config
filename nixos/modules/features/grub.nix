# Module that configures grub

{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.myNixOS;
in {
  options.myNixOS.grub.flavor = lib.mkOption {
    default = "orange";
    description = "Sleek grub theme flavor (white|dark|orange|bigSur)";
  };

  config = let
    # Make package with override of theme
    # This override is here instead of overrides cause it needs to be changed
    # using system config options
    grub-theme = pkgs.unstable.sleek-grub-theme.override {
      withStyle = cfg.grub.style;
    };
  in {

    # Configure the boot menu
    boot.loader.grub = {
      enable = true;
      useOSProber = true;
      memtest86.enable = true;
      theme = grub-theme;
    };

    # Make sure our package is installed
    environment.systemPackages = [
      grub-theme
    ];
  };
}
