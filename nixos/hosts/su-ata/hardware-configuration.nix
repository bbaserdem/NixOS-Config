# Hardware configuration file
{
  config,
  inputs,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "ahci"
        "nvme"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = [
      ];
    };
    kernel.sysctl = {"vm.swappiness" = 0;};
    kernelModules = [
      "kvm-intel"
      "corsair-psu"
      "coretemp"
      "nct6775"
      "hid"
      "usb_hid"
    ];
    extraModulePackages = [];
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
  };

  # System options
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Hardware options
  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  environment.systemPackages = with pkgs; [
    lm_sensors
    liquidctl
  ];
}
