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
  
  # Install virtio-win drivers
  environment.systemPackages = with pkgs; [
    virtio-win
  ];
}
