{pkgs, ...}: let
  delugeStartup = import ./deluge-startup.nix {inherit pkgs;};
in
pkgs.dockerTools.buildImage {
  name = "deluge-daemon";
  tag = "latest";

  copyToRoot = pkgs.buildEnv {
    name = "deluge-root";
    paths = with pkgs; [
      deluge
      python3
      curl
      bash
      coreutils
      shadow
      su
      delugeStartup
    ];
    pathsToLink = ["/bin" "/sbin" "/etc" "/lib"];
  };

  runAsRoot = ''
    #!${pkgs.runtimeShell}
    mkdir -p /config
    mkdir -p /downloads
    mkdir -p /var/log

    # Create deluge user
    groupadd -r deluge || true
    useradd -r -g deluge -d /config -s /bin/bash deluge || true
    chown -R deluge:deluge /config /downloads
  '';

  config = {
    User = "deluge";
    WorkingDir = "/config";
    Env = [
      "PATH=/bin:/sbin"
      "PYTHONPATH=${pkgs.deluge}/lib/python3.11/site-packages"
    ];
    Cmd = ["${delugeStartup}"];
    ExposedPorts = {
      "8112/tcp" = {};
      "58846/tcp" = {};
    };
    Volumes = {
      "/config" = {};
      "/downloads" = {};
    };
  };
}