# utils.nix
# A program list of utility programs that needs to be system wide installed
{
  pkgs,
  inputs,
  ...
}: {
  # Editor to use
  nixCats = {
    enable = true;
    nixpkgs_version = inputs.nixpkgs-unstable;
    packageNames = ["neovim-nixCats-none"];
  };

  environment = {
    systemPackages = with pkgs; [
      home-manager # Home-manager
      light # Backlight
      smartmontools # Harddrive health
      kmon # Kernel module checker
      ncdu # Disk usage monitor
      nethogs # Network usage monitor
      lm_sensors # Sensors readout
      gparted # Partition manager, gui
      udisks # Storage device manager
      lshw # Hardware utility
      polkit # Privilege utility
      sudo # Privilege escalation
      inotify-tools # File watching
      killall # Program killer
    ];
    # Let us define global sudo and visual editors
    variables = {
      EDITOR = "nx-none";
      VISUAL = "nx-none";
    };
  };
}
