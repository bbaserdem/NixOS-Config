# Configuring KeepassXC
{pkgs, ...}: {
  programs.keepassxc = {
    enable = true;
    settings = {
      Browser.Enabled = true;
      GUI = {
        AdvancedSettings = true;
        CompactMode = true;
        HidePasswords = true;
      };
      SSHAgent.Enabled = true;
    };
  };
}
