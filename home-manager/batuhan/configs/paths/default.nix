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
    # Enables this feature
    enable = true;
    # Directories
    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";
    # User dirs
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Media/Documents";
      music = "${config.home.homeDirectory}/Media/Music";
      pictures = "${config.home.homeDirectory}/Media/Pictures";
      templates = "${config.home.homeDirectory}/Media/Templates";
      videos = "${config.home.homeDirectory}/Media/Videos";
      publicShare = "${config.home.homeDirectory}/Shared/Public";
      download = "${config.home.homeDirectory}/Sort/Downloads";
      extraConfig = {
        XDG_MEDIA_DIR = "${config.home.homeDirectory}/Media";
        XDG_NOTES_DIR = "${config.home.homeDirectory}/Media/Notes";
        XDG_PROJECTS_DIR = "${config.home.homeDirectory}/Projects";
        XDG_STAGING_DIR = "${config.home.homeDirectory}/Sort";
        XDG_PHONE_DIR = "${config.home.homeDirectory}/Shared/Android";
      };
    };
  };
  # My flake directory
  home.sessionVariables = {
    FLAKE = "${xdg.userDirs.extraConfig.XDG_PROJECTS_DIR}/NixOS";
  };
  # Aliases to navigate quickly
  programs.zsh.shellAliases = {
    cd-flake = "cd ${home.sessionVariables.FLAKE}";
    cd-notes = "cd ${xdg.userDirs.extraConfig.XDG_NOTES_DIR}";
    cd-media = "cd ${xdg.userDirs.extraConfig.XDG_MEDIA_DIR}";
    cd-music = "cd ${xdg.userDirs.music}";
    cd-image = "cd ${xdg.userDirs.pictures}";
    cd-video = "cd ${xdg.userDirs.videos}";
    cd-downl = "cd ${xdg.userDirs.download}";
  };
}
