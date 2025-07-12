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
      kernelModules = [
        "evdi"
      ];
      luks.devices."Yel-Ana_Linux".device = "/dev/disk/by-partlabel/Crypt_Yel-Ana_Linux";
    };
    kernel.sysctl = {"vm.swappiness" = 0;};
    kernelModules = ["kvm-amd"];
    extraModulePackages = [
      config.boot.kernelPackages.evdi
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

  systemd.services = {
    # Fixing a systemd bug
    systemd-logind.environment = {
      SYSTEMD_BYPASS_HIBERNATION_MEMORY_CHECK = "1";
    };
    # Making displaylink run in gnome
    dlm.wantedBy = ["multi-user.target"];
    # This is to make display-link work in KDE
    displaylink-server = {
      enable = true;
      # Ensure it starts after udev has done its work
      after = ["systemd-udevd.service"];
      wantedBy = ["multi-user.target"];
      # *** THIS IS THE CRITICAL 'serviceConfig' BLOCK ***
      serviceConfig = {
        Type = "simple"; # Or "forking" if it forks (simple is common for daemons)
        # The ExecStart path points to the DisplayLinkManager binary provided by the package
        ExecStart = "${pkgs.displaylink}/bin/DisplayLinkManager";
        # User and Group to run the service as (root is common for this type of daemon)
        User = "root";
        Group = "root";
        # Environment variables that the service itself might need
        # Environment = [ "DISPLAY=:0" ]; # Might be needed in some cases, but generally not for this
        Restart = "on-failure";
        RestartSec = 5; # Wait 5 seconds before restarting
      };
    };
  };
  boot.initrd.systemd.enable = true;
  swapDevices = [
    {device = "/swap/swapfile";}
  ];

  # DisplayLink device enabling
  services.xserver.videoDrivers = [
    "displaylink"
    "modesetting"
  ];
  environment.systemPackages = with pkgs; [
    displaylink
  ];

  # System options
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
