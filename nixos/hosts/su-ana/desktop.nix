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
      {path = "/Applications/Obsidian.app/";}
      {path = "/Applications/iTerm.app/";}
      {path = "/Applications/kitty.app/";}
      {path = "/Applications/KeePassXC.app/";}
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
}
