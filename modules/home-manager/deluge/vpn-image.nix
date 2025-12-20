{pkgs, ...}: let
  vpnStartup = import ./vpn-startup.nix {inherit pkgs;};
in
pkgs.dockerTools.buildImage {
  name = "deluge-vpn-wireguard";
  tag = "latest";

  copyToRoot = pkgs.buildEnv {
    name = "vpn-root";
    paths = with pkgs; [
      wireguard-tools
      iproute2
      nftables
      curl
      bash
      coreutils
      procps
      vpnStartup
    ];
    pathsToLink = ["/bin" "/sbin"];
  };

  runAsRoot = ''
    #!${pkgs.runtimeShell}
    mkdir -p /etc/wireguard
    mkdir -p /var/run
  '';

  config = {
    Env = [
      "PATH=/bin:/sbin"
    ];
    Cmd = ["${vpnStartup}"];
    ExposedPorts = {
      "8112/tcp" = {};
      "58846/tcp" = {};
    };
  };
}