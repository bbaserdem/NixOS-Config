# Configuring KeepassXC
{
  pkgs,
  lib,
  ...
}:
lib.mkMerge [
  {
    programs.keepassxc = {
      enable = true;
      autostart = true;
      settings = {
        General = {
          ConfigVersion = 2;
          MinimizeAfterUnlock = true;
        };
        PasswordGenerator = {
          AdditionalChars = "";
          ExcludedChars = "";
        };
        Browser = {
          Enabled = true;
        };
        GUI = {
          AdvancedSettings = true;
          ColorPasswords = true;
          CompactMode = true;
          HidePasswords = true;
          MinimizeOnClose = true;
          MinimizeOnStartup = true;
          MinimizeToTray = true;
          ShowTrayIcon = true;
          TrayIconAppearance = "colorful";
        };
        SSHAgent.Enabled = true;
      };
    };
  }
  (lib.mkIf (pkgs.stdenv.hostPlatform.isLinux) {
    programs.keepassxc.settings.Browser = {
      CustomProxyLocation = false;
      UpdateBinaryPath = false;
      AlwaysAllowAccess = true;
      AlwaysAllowUpdate = true;
    };

    # Create a drop-in for the XDG autostart service to wait for system tray
    xdg.configFile."systemd/user/app-org.keepassxc.KeePassXC@autostart.service.d/wait-for-tray.conf".text = ''
      [Unit]
      After=tray.target
      Wants=tray.target
      
      [Service]
      # Work around race condition with tray providers in Hyprland
      ExecStartPre=${pkgs.writeShellScript "keepassxc-wait-tray" ''
        # Only delay in Hyprland where dms needs time to initialize
        if [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ] && [ -n "$WAYLAND_DISPLAY" ]; then
          # Wait a bit for dms tray to initialize
          sleep 2
        fi
      ''}
    '';
  })
]
