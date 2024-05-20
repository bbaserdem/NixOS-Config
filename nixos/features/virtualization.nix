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

  # Enable docker
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # Add our user to docker group
  users.extraGroups.docker.members = [config.myNixOS.userName];

  # Example docker as systemd service
  #virtualisation.oci-containers = {
  #  backend = "docker";
  #  containers = {
  #    foo = {
  #      # ...
  #    };
  #  };
  #};

  # Install virtio-win drivers
  environment.systemPackages = with pkgs; [
    spice-gtk
    virtio-win
    docker-client
  ];
}
