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
      {path = "/System/Applications/Home.app/";}
      {path = "/System/Applications/swmpc.app/";}
      {path = "/Applications/iTerm.app/";}
      {path = "/Users/batuhan/Applications/Home Manager Trampolines/Firefox.app/";}
      {path = "/Applications/Slack.app/";}
      {path = "/System/Applications/Mail.app/";}
      {path = "/Applications/Repo Prompt.app/";}
      {path = "/Applications/Cursor.app/";}
      {path = "/Applications/Claude.app/";}
      {path = "/Applications/Perplexity.app/";}
      {path = "/System/Applications/System Settings.app/";}
      {path = "/System/Applications/Utilities/Activity Monitor.app/";}
    ];
  };

  services = {
    # SketchyBar config
    sketchybar = {
      enable = false;
    };

    # JankyBorders config
    jankyborders = {
      enable = true;
      active_color = "0xB0${config.lib.stylix.colors.cyan}";
      inactive_color = "0xB0${config.lib.stylix.colors.base07}";
    };
  };
}
