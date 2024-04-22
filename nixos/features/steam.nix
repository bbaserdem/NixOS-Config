# Module that enables steam, has to be system level
{
  pkgs,
  lib,
  ... 
}: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };
}
