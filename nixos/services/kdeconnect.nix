# Opens KDE connect ports
{...}: let
  kdeConnectPortRange = {
    from = 1714;
    to = 1764;
  };
in {
  # Open the ports necessary for KDE connect (for now)
  # From https://github.com/NixOS/nixpkgs/blob/nixos-24.11/nixos/modules/programs/kdeconnect.nix
  networking.firewall = {
    allowedTCPPortRanges = [kdeConnectPortRange];
    allowedUDPPortRanges = [kdeConnectPortRange];
  };
}
