# Configuration test for our google account
{
  config,
}: {
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
      port = 587;
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
};
