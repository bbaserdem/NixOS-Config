# Module that enables steam, has to be system level
{
  pkgs,
  lib,
  ... 
}: {
  # Enable steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };
  # Enable gaming daemon
  programs.gamemode.enable = true;
  # Install a machine performance viewer
  environment.systemPackages = with pkgs; [
    mangohud
    protonup
  ]
}
