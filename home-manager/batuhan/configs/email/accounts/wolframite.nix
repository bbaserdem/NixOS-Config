# Configuration test for our google account
{
  config,
  ...
}: {
  # Need to wait for secrets for imapnotify
  systemd.user.services.imapnotify-nsfw.Unit.After = [ "sops-nix.service" ];
  accounts.email.accounts.nsfw = {
    # Main information about the account
    address = "wolf.x.ramite@gmail.com";
    realName = "Wolf Ramite";
    maildir.path = "NSFW";
    passwordCommand = "cat ${config.sops.secrets."google/nsfw".path}";
    # Signature for sending mail
    signature = {
      delimiter = ''
        ---
      '';
      text = "Wolf.Ramite";
      showSignature = "append";
    };

    # Global account info
    flavor = "gmail.com";
    gpg = {
      encryptByDefault = false;
      key = "";
      signByDefault = false;
    };
    imap.host = "imap.gmail.com";
    smtp = {
      host = "smtp.gmail.com";
    };

    # Notification, and action for when email arrives
    imapnotify = {
      enable = true;
      boxes = [
        "Inbox"
      ];
      #onNotify = "\${pkgs.isync}/bin/mbsync test-%s";
      #onNotifyPost = {
      #  mail = "\${pkgs.notmuch}/bin/notmuch new && \${pkgs.libnotify}/bin/notify-send 'New mail arrived'";
      #};
    };

    # Mail sending
    msmtp = {
      enable = true;
    };

    # IMAP folder synching
    lieer = {
      enable = true;
      settings = {
        ignore_empty_history = true;
        ignore_remote_labels = [];
      };
      sync = {
        enable = true;
        frequency = "*:0/15";
      };
    };

    # Email tags
    notmuch = {
      enable = true;
      neomutt = {
        enable = true;
      };
    };

    # TUI interface
    neomutt = {
      enable = true;
      mailboxType = "imap";
    };

    # GUI interface
    astroid = {
      enable = true;
    };
  };
}