# Module that configures grub

{ pkgs, lib, ... }: {
  #myNixOS.sharedSettings.grubTheme = lib.mkDefault "orange";
  boot.loader.grub = {
    enable = true;
    useOSProber = true;
    memtest86.enable = true;
    theme = pkgs.sleek-grub-theme;
  };
  environment.systemPackages = [
    pkgs.sleek-grub-theme
  ];
}
