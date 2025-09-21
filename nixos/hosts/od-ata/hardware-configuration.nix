{
  config,
  pkgs,
  ...
}: {
  system.nixos.tags = [
    "raspberry-pi-${config.boot.loader.raspberryPi.variant}"
    config.boot.loader.raspberryPi.bootloader
    config.boot.kernelPackages.kernel.version
  ];
}
