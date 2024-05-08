# Hardware configuration file
{
  config,
  lib,
  pkgs,
  modulesPath,
  inputs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.hardware.nixosModules.framework-13-7040-amd
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "thunderbolt"
        "uas"
        "sd_mod"
      ];
      kernelModules = [ ];
      luks.devices."Yel-Ana_NixOS".device = "/dev/disk/by-partlabel/Crypt_Yel-Ana_NixOS";
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
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
      label = "Yel-Ana_NixOS";
      fsType = "btrfs";
      options = [
        "subvol=@nixos-root"
        "compress=zstd"
        "noatime"
      ];
    };
    "/nix" = {
      label = "Yel-Ana_NixOS";
      fsType = "btrfs";
      options = [
        "subvol=@nixos-store"
        "compress=zstd"
        "noatime"
      ];
    };
    "/persist" = {
      label = "Yel-Ana_NixOS";
      fsType = "btrfs";
      options = [
        "subvol=@nixos-persist"
        "compress=zstd"
        "strictatime"
        "lazytime"
      ];
    };
    "/var/log" = {
      label = "Yel-Ana_NixOS";
      fsType = "btrfs";
      options = [
        "subvol=@nixos-log"
        "compress=zstd"
        "strictatime"
        "lazytime"
      ];
    };
    "/var/lib/machines" = {
      label = "Yel-Ana_NixOS";
      fsType = "btrfs";
      options = [
        "subvol=@nixos-machines"
        "compress=zstd"
        "noatime"
      ];
    };
    "/var/lib/portables" = {
      label = "Yel-Ana_NixOS";
      fsType = "btrfs";
      options = [
        "subvol=@nixos-portables"
        "compress=zstd"
        "noatime"
      ];
    };
    "/home" = {
      label = "Yel-Ana_NixOS";
      fsType = "btrfs";
      options = [
        "subvol=@home"
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
    "/boot" = { label = "Yel-Ana_ESP"; };
  };
  swapDevices = [
    { label = "Yel-Ana_NixOS_S"; }
  ];

  # System options
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
