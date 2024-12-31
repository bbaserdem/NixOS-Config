# Neomutt config
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./wolframite.nix
  ];

  # Primary account
  accounts.email.accounts.nsfw.primary = true;
  
  # Global settings
  accounts.email = {
    maildirBasePath = "${config.xdg.dataHome}/mail";
  };

  # Specific apps usage
  programs.lieer.enable = true;
  programs.msmtp.enable = true;
  programs.astroid = {
    enable = true;
    externalEditor = null;
    pollScript = "";
  };
  services.imapnotify.enable = true;

  # Neomutt config
  programs.neomutt = {
    enable = true;
  };
}
