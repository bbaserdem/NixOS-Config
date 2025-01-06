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
  # Install machine performance viewer
  environment.systemPackages = with pkgs; [
    mangohud
    protonup
    bubblewrap
  ];
}
