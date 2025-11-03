# Configuring KeepassXC
{pkgs, ...}: {
  programs.keepassxc = {
    enable = true;
    settings = {
      General = {
        ConfigVersion = 2;
      };
      PasswordGenerator = {
        AdditionalChars = "";
        ExcludedChars = "";
      };
      Browser = {
        Enabled = true;
        CustomProxyLocation = false;
        UpdateBinaryPath = false;
        AlwaysAllowAccess = true;
        AlwaysAllowUpdate = true;
      };
      GUI = {
        AdvancedSettings = true;
        CompactMode = true;
        HidePasswords = true;
      };
      SSHAgent.Enabled = true;
    };
  };
}
