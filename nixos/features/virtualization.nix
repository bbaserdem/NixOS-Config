{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  # Enable libvirtd
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Enable USB redirection
  virtualisation.spiceUSBRedirection.enable = true;

  # Install virtio-win drivers
  environment.systemPackages = with pkgs; [
    spice-gtk
    virtio-win
  ];
}
