# utils.nix
# A program list of utility programs that needs to be system wide installed

{ pkgs, lib, config, ... }: {
  # Install archiving tools into userspace
  environment.systemPackages = with pkgs; [
    home-manager      # Home-manager
    light             # Backlight
    smartmontools     # Harddrive health
    kmon              # Kernel module checker
    ncdu              # Disk usage monitor
    nethogs           # Network usage monitor
    lm_sensors        # Sensors readout
    gparted           # Partition manager, gui
    udisks            # Storage device manager
    lshw              # Hardware utility
    polkit            # Privilege utility
    sudo              # Privilege escalation
    inotify-tools     # File watching
  ];
}
