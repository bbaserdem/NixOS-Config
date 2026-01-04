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
    
    xdg.configFile."systemd/user/app-org.keepassxc.KeePassXC@autostart.service.d/wait-for-tray.conf".text = ''
      [Unit]
      After=tray.target
      Wants=tray.target
      
      [Service]
      ExecStartPre=/run/current-system/sw/bin/sleep 5
    '';
  })
]
