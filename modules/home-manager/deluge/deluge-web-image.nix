{pkgs, ...}: let
  delugeWebStartup = pkgs.writeShellScript "deluge-web-startup" ''
    # Wait for daemon to be ready
    while ! ${pkgs.curl}/bin/curl -s --connect-timeout 5 localhost:58846 > /dev/null; do
      echo "Waiting for Deluge daemon..."
      sleep 5
    done

    echo "Deluge daemon ready, starting web UI..."

    # Start Deluge web UI
    exec ${pkgs.deluge}/bin/deluge-web --do-not-daemonize --config /config
  '';
in
pkgs.dockerTools.buildImage {
  name = "deluge-web";
  tag = "latest";

  copyToRoot = pkgs.buildEnv {
    name = "deluge-web-root";
    paths = with pkgs; [
      deluge
      python3
      curl
      bash
      coreutils
      shadow
      su
      delugeWebStartup
    ];
    pathsToLink = ["/bin" "/sbin" "/etc" "/lib"];
  };

  runAsRoot = ''
    #!${pkgs.runtimeShell}
    mkdir -p /config
    mkdir -p /var/log

    # Create deluge user
    groupadd -r deluge || true
    useradd -r -g deluge -d /config -s /bin/bash deluge || true
    chown -R deluge:deluge /config
  '';

  config = {
    User = "deluge";
    WorkingDir = "/config";
    Env = [
      "PATH=/bin:/sbin"
      "PYTHONPATH=${pkgs.deluge}/lib/python3.11/site-packages"
    ];
    Cmd = ["${delugeWebStartup}"];
    ExposedPorts = {
      "8112/tcp" = {};
    };
    Volumes = {
      "/config" = {};
    };
  };
}