# Module that configures polkit
{
  pkgs,
  lib,
  ...
}: {
  security.polkit = {
    enable = true;
    # Enable users group to boot the system
    extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (
          subject.isInGroup("users")
            && (
              action.id == "org.freedesktop.login1.reboot" ||
              action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
              action.id == "org.freedesktop.login1.power-off" ||
              action.id == "org.freedesktop.login1.power-off-multiple-sessions"
            )
        )
        {
          return polkit.Result.YES;
        }
      })
    '';
  };
}
