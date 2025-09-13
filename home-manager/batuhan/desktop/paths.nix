#
{config, ...}: let
  flakeDir = "${config.xdg.userDirs.extraConfig.XDG_PROJECTS_DIR}/Nix/NixOS";
in {
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

  # My flake directory, used with NH as well
  home.sessionVariables = {
    FLAKE = "${flakeDir}";
    NH_FLAKE = "${flakeDir}";
  };

  # Aliases to navigate quickly
  programs.zsh.shellAliases = {
    cd-flake = "cd ${flakeDir}";
    cd-ncats = "cd ${config.xdg.userDirs.extraConfig.XDG_PROJECTS_DIR}/NixCats";
    cd-projs = "cd ${config.xdg.userDirs.extraConfig.XDG_PROJECTS_DIR}";
    cd-notes = "cd ${config.xdg.userDirs.extraConfig.XDG_NOTES_DIR}";
    cd-media = "cd ${config.xdg.userDirs.extraConfig.XDG_MEDIA_DIR}";
    cd-music = "cd ${config.xdg.userDirs.music}";
    cd-image = "cd ${config.xdg.userDirs.pictures}";
    cd-video = "cd ${config.xdg.userDirs.videos}";
    cd-downl = "cd ${config.xdg.userDirs.download}";
  };

  # Add the bookmarks to file browser
  gtk.gtk3.bookmarks = [
    "file://${config.xdg.userDirs.documents}"
    "file://${config.xdg.userDirs.music}"
    "file://${config.xdg.userDirs.pictures}"
    "file://${config.xdg.userDirs.videos}"
    "file://${config.xdg.userDirs.extraConfig.XDG_MEDIA_DIR}"
    "file://${config.xdg.userDirs.extraConfig.XDG_PHONE_DIR}"
    "file://${config.xdg.userDirs.download}"
    "file://${config.xdg.userDirs.extraConfig.XDG_PROJECTS_DIR}"
  ];
}
