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
          CompactMode = true;
          HidePasswords = true;
          MinimizeOnStartup = true;
        };
        SSHAgent.Enabled = true;
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
  }
  (lib.mkIf (pkgs.stdenv.hostPlatform.isLinux) {
    programs.keepassxc.settings.Browser = {
      CustomProxyLocation = false;
      UpdateBinaryPath = false;
      AlwaysAllowAccess = true;
      AlwaysAllowUpdate = true;
    };
  })
]
