# Configuration test for our google account
{
  config,
  ...
}: {
  # Need to wait for secrets for imapnotify
  systemd.user.services.imapnotify-spam.Unit.After = [ "sops-nix.service" ];
  accounts.email.accounts.spam = {
    # Main information about the account
    address = "zbatu.bogus@gmail.com";
    realName = "Z Batuhan Batu";
    maildir.path = "Spam";
    passwordCommand = "cat ${config.sops.secrets."google/spam".path}";
    # Signature for sending mail
    signature = {
      delimiter = ''
        ---
      '';
      text = "Batuhan";
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
