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
    grub-theme = pkgs.sleek-grub-theme.override {
      withStyle = cfg.grub.flavor;
    };
  in {
    # Configure the boot menu
    boot.loader.grub = {
      enable = true;
      efiSupport = true;
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
