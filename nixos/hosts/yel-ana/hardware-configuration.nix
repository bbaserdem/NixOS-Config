# Hardware configuration file
{
  config,
  lib,
  modulesPath,
  inputs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.hardware.nixosModules.framework-13-7040-amd
    inputs.fw-fanctrl.nixosModules.default
  ];

  # Fan control
  programs.fw-fanctrl = {
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

  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "thunderbolt"
        "uas"
        "sd_mod"
      ];
      kernelModules = [];
      luks.devices."Yel-Ana_Linux".device = "/dev/disk/by-partlabel/Crypt_Yel-Ana_Linux";
    };
    kernel.sysctl = {"vm.swappiness" = 0;};
    kernelModules = ["kvm-amd"];
    extraModulePackages = [];
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
  };
  # Use crypttab to unlock partition after init
  environment.etc.crypttab.source = ./crypttab;

  # File system layout
  fileSystems = {
    # BTRFS main partition mount points
    "/" = {
      label = "Yel-Ana_Linux";
      fsType = "btrfs";
      options = [
        "subvol=@nixos-root"
        "compress=zstd"
        "noatime"
      ];
    };
    "/swap" = {
      label = "Yel-Ana_Linux";
      fsType = "btrfs";
      options = [
        "subvol=@nixos-swap"
        "compress=zstd"
        "noatime"
      ];
    };
    "/nix" = {
      label = "Yel-Ana_Linux";
      fsType = "btrfs";
      options = [
        "subvol=@nixos-store"
        "compress=zstd"
        "noatime"
      ];
    };
    "/persist" = {
      label = "Yel-Ana_Linux";
      fsType = "btrfs";
      options = [
        "subvol=@nixos-persist"
        "compress=zstd"
        "strictatime"
        "lazytime"
      ];
    };
    "/var/log" = {
      label = "Yel-Ana_Linux";
      fsType = "btrfs";
      options = [
        "subvol=@nixos-log"
        "compress=zstd"
        "strictatime"
        "lazytime"
      ];
    };
    "/var/lib/machines" = {
      label = "Yel-Ana_Linux";
      fsType = "btrfs";
      options = [
        "subvol=@nixos-machines"
        "compress=zstd"
        "noatime"
      ];
    };
    "/var/lib/portables" = {
      label = "Yel-Ana_Linux";
      fsType = "btrfs";
      options = [
        "subvol=@nixos-portables"
        "compress=zstd"
        "noatime"
      ];
    };
    "/home" = {
      label = "Yel-Ana_Linux";
      fsType = "btrfs";
      options = [
        "subvol=@home"
        "compress=zstd"
        "strictatime"
        "lazytime"
      ];
    };
    "/mnt/filesystem" = {
      label = "Yel-Ana_Linux";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "strictatime"
        "lazytime"
      ];
    };
    # Data partition
    "/home/data" = {
      label = "Yel-Ana_Data";
      fsType = "ext4";
      options = [
        "strictatime"
        "lazytime"
      ];
    };
    # ESP
    "/boot" = {label = "Yel-Ana_ESP";};
  };

  # Systemd bug
  systemd.services.systemd-logind.environment = {
    SYSTEMD_BYPASS_HIBERNATION_MEMORY_CHECK = "1";
  };
  boot.initrd.systemd.enable = true;
  swapDevices = [
    {device = "/swap/swapfile";}
  ];

  # System options
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
