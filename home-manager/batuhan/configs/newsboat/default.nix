# Configuring Newsboat
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
  programs.newsboat = {
    enable = true;
    autoReload = true;
    maxItems = 0;
    reloadTime = 10;
    extraConfig = ''
      notify-always yes
      notify-format "%f unread feeds ($n unread in total)"
      notify-program newsboat-notify.sh
      notify-beep no
      confirm-exit no
      urls-source "local"
      datetime-format "%d/%m/%y"
      delete-played-files no
      download-path "~/Sort/Downloads/Podcast %n %h"
      max-downloads 3
      player "mpd"
    '';
  };
}
