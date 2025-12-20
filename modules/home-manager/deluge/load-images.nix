{pkgs, ...}: let
  vpnImage = import ./vpn-image.nix {inherit pkgs;};
  delugeImage = import ./deluge-image.nix {inherit pkgs;};
  delugeWebImage = import ./deluge-web-image.nix {inherit pkgs;};
in
pkgs.writeShellScriptBin "load-deluge-vpn-images" ''
  echo "Loading VPN image..."
  ${pkgs.docker}/bin/docker load < ${vpnImage}
  echo "Loading Deluge daemon image..."
  ${pkgs.docker}/bin/docker load < ${delugeImage}
  echo "Loading Deluge web image..."
  ${pkgs.docker}/bin/docker load < ${delugeWebImage}
  echo "Images loaded successfully"
''