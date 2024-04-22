# 
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  myLib,
  rootPath,
  ...
}: {
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
    desktop =     "${config.home.homeDirectory}/Desktop";
    documents =   "${config.home.homeDirectory}/Media/Documents";
    music =       "${config.home.homeDirectory}/Media/Music";
    pictures =    "${config.home.homeDirectory}/Media/Pictures";
    templates =   "${config.home.homeDirectory}/Media/Templates";
    videos =      "${config.home.homeDirectory}/Media/Videos";
    publicShare = "${config.home.homeDirectory}/Shared/Public";
    download =    "${config.home.homeDirectory}/Sort/Downloads";
    extraConfig = {
      XDG_PROJECTS_DIR = "${config.home.homeDirectory}/Projects";
      XDG_STAGING_DIR = "${config.home.homeDirectory}/Sort";
      XDG_PHONE_DIR = "${config.home.homeDirectory}/Shared/Android";
    };
  };
  # My flake directory
  home.sessionVariables = {
    FLAKE = "${config.xdg.userDirs.extraConfig.XDG_PROJECTS_DIR}/NixOS";
  };
}
