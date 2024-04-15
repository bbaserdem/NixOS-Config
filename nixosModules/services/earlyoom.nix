# Earlyoom; daemon that shuts down apps before they can create OOM

{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  # Enable and configure earlyoom
  services.earlyoom = {
    enable = true;
    # Enable d-bus notifications
    enableNotifications = true;
    # Main threshold of %free for SIGTERM, kill is for SIGKILL 
    freeMemThreshold = 7;
    freeMemKillThreshold = 3;
    extraArgs = [
      "-g"
      "--prefer '(^|/)(java|chromium)$'"
      "--avoid '(^|/)(rsync)$'"
    ];
  };
}
