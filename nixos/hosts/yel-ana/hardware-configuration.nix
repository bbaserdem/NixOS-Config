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
    extraModulePackages = with config.boot.kernelPackages; [
      framework-laptop-kmod
    ];
    kernelModules = [
      "kvm-amd"
      "framework-laptop-kmod"
    ];
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

    # Fixes for AMD Phoenix APU (Framework 7040 series) MST issues
    kernelParams = [
      "amdgpu.sg_display=0" # Disable scatter-gather for Phoenix APU display corruption
      "amdgpu.tmz=0" # Disable Trusted Memory Zone
      "amdgpu.sched_policy=2" # Use static queue assignment
      "amdgpu.noretry=1" # Don't retry on page faults
      "amdgpu.lockup_timeout=0" # Disable GPU lockup detection
      "video=DP-2:1920x1080@60" # Force lower resolution on second display
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
