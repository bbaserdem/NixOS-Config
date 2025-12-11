# Hardware configuration file
{
  config,
  lib,
  modulesPath,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.hardware.nixosModules.framework-13-7040-amd
  ];

  # Fan control
  # TODO: change this to nixos module in new version
  hardware = {
    # MST fix
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;

    # Fan control
    fw-fanctrl = {
      enable = true;
      config = {
        defaultStrategy = "medium";
        strategyOnDischarging = "lazy";
        strategies = {
          "lazy" = {
            fanSpeedUpdateFrequency = 5;
            movingAverageInterval = 30;
            speedCurve = [
              {
                temp = 0;
                speed = 15;
              }
              {
                temp = 50;
                speed = 15;
              }
              {
                temp = 65;
                speed = 25;
              }
              {
                temp = 70;
                speed = 35;
              }
              {
                temp = 75;
                speed = 50;
              }
              {
                temp = 85;
                speed = 100;
              }
            ];
          };
        };
      };
    };
  };

  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "thunderbolt"
        "uas"
        "sd_mod"
      ];
    };
    kernel.sysctl = {"vm.swappiness" = 0;};
    kernelModules = ["kvm-amd"];
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        # For EFI support
        device = "nodev";
      };
    };

    # MST fix for AMD Phoenix APU - minimal parameters to avoid boot issues
    kernelParams = [
      "amdgpu.sg_display=0" # Disable scatter-gather for display (fixes Phoenix MST)
    ];
    kernelPackages = pkgs.linuxPackages_latest;
  };
  # Use crypttab to unlock partition after init
  environment.etc.crypttab.source = ./crypttab;

  systemd.services = {
    # Fixing a systemd bug
    systemd-logind.environment = {
      SYSTEMD_BYPASS_HIBERNATION_MEMORY_CHECK = "1";
    };
  };
  boot.initrd.systemd.enable = true;
  swapDevices = [
    {device = "/swap/swapfile";}
  ];

  # System options
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
