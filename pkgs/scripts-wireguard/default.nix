{pkgs, ...}: let
  add-client = pkgs.callPackage ./add-client.nix {};
  remove-client = pkgs.callPackage ./remove-client.nix {};
  list-clients = pkgs.callPackage ./list-clients.nix {};
in (pkgs.symlinkJoin {
  name = "user-wireguard";
  paths = [
    add-client
    remove-client
    list-clients
  ];
})