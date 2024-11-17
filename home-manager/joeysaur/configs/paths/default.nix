#
{
  config,
  pkgs,
  ...
}: rec {
  # Local binaries
  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];
  # XDG paths
  xdg = {
    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";
  };
  # User dirs
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "${config.home.homeDirectory}/Desktop";
    documents = "${config.home.homeDirectory}/Media/Documents";
    music = "${config.home.homeDirectory}/Media/Music";
    pictures = "${config.home.homeDirectory}/Media/Pictures";
    templates = "${config.home.homeDirectory}/Media/Templates";
    videos = "${config.home.homeDirectory}/Media/Videos";
    publicShare = "${config.home.homeDirectory}/Shared/Public";
    download = "${config.home.homeDirectory}/Downloads";
  };
  programs.zsh.shellAliases = {
    cd-music = "cd ${xdg.userDirs.music}";
    cd-image = "cd ${xdg.userDirs.pictures}";
    cd-video = "cd ${xdg.userDirs.videos}";
    cd-downl = "cd ${xdg.userDirs.download}";
  };
}
