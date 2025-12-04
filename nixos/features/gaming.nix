# <flake>/nixos/features/gaming.nix
# Module that enables steam, has to be system level
{pkgs, ...}: {
  # Enable steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };
  # Create steam user
  users.users.steam = {
    isNormalUser = true;
    initialPassword = "";
    description = "Steam Player";
    extraGroups = [
      "networkmanager"
    ];
  };
  # Enable gaming daemon
  programs.gamemode.enable = true;
  # Install machine performance viewer, and other gaming things
  environment.systemPackages = with pkgs; [
    lutris
    heroic
    rpcs3
    mangohud
    protonup-ng
    bubblewrap
  ];
}
