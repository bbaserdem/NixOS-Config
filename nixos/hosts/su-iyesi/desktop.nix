{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./dock.nix
  ];
  # Dock config
  local.dock = {
    enable = true;
    username = "batuhan";
    entries = [
      {path = "/Applications/Slack.app/";}
      {path = "/Applications/Firefox.app/";}
      {path = "/System/Applications/Mail.app/";}
      {path = "${pkgs.kitty}/Applications/kitty.app/";}
      {path = "/System/Applications/Utilities/Terminal.app/";}
      {path = "/Applications/Claude.app/";}
      {path = "/System/Applications/System Settings.app/";}
      {path = "/System/Applications/Home.app/";}
      {path = "/System/Applications/Utilities/Activity Monitor.app/";}
    ];
  };

  # SketchyBar config

  # AeroSpace config

  # JankyBorders config
}
