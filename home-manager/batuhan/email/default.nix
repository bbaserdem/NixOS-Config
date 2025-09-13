# Neomutt config
{config, ...}: {
  imports = [
    ./applist
    ./neomutt
    ./accounts
  ];

  # Grab the password
  sops.secrets = {
    "google/client_secret.json" = {};
    "google/orig" = {};
    "google/work" = {};
    "google/spam" = {};
    "google/nsfw" = {};
  };

  # Global settings
  accounts.email = {
    maildirBasePath = "${config.xdg.dataHome}/mail";
  };

  # Specific apps usage
  programs = {
    lieer.enable = true;
    msmtp.enable = true;
    notmuch = {
      enable = true;
      new.tags = [];
    };
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

  # A shell alias
  programs.zsh.shellAliases.cd-email = "cd ${config.xdg.dataHome}/mail";
}
