# Neomutt config
{
  config,
  ...
}: {
  imports = [
    ./wolframite.nix
  ];

  # Grab the password
  sops.secrets = {
    "google/orig" = {};
    "google/work" = {};
    "google/spam" = {};
    "google/nsfw" = {};
  };

  # Primary account
  accounts.email.accounts.nsfw.primary = true;
  
  # Global settings
  accounts.email = {
    maildirBasePath = "${config.xdg.dataHome}/mail";
  };

  # Specific apps usage
  programs = {
    lieer.enable = true;
    msmtp.enable = true;
    notmuch.enable = true;
    astroid = {
      enable = true;
      externalEditor = null;
      pollScript = "";
    };
  };
  services = {
    imapnotify.enable = true;
    lieer.enable = true;
  };

  # Neomutt config
  programs.neomutt = {
    enable = true;
  };
}
