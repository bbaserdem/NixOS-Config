# Configuration test for our google account
{
  config,
  ...
}:
let
  account = "spam";
  address = "zbatu.bogus";
  name = "Z Batuhan Batu";
in {
  # Need to wait for secrets for imapnotify
  systemd.user.services."imapnotify-${account}".Unit.After = [ "sops-nix.service" ];

  accounts.email.accounts.spam = {
    # Main information about the account
    address = "${address}@gmail.com";
    realName = name;
    maildir.path = account;
    passwordCommand = "cat ${config.sops.secrets."google/${account}".path}";
    # Signature for sending mail
    signature = {
      delimiter = ''
        ---
      '';
      text = name;
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
        virtualMailboxes = [
          {
            name = "[${account}] Inbox";
            query = "(tag:inbox -tag:promotions -tag:social) OR (tag:inbox and tag:flagged)";
            limit = 1000;
          } {
            name = "[${account}] Archive";
            query = "not tag:inbox and not tag:spam";
            limit = 1000;
          } {
            name = "[${account}] Personal";
            query = "tag:personal";
            limit = 1000;
          } {
            name = "[${account}] Flagged";
            query = "tag:flagged";
            limit = 1000;
          } {
            name = "[${account}] Promotions";
            query = "tag:promotions";
            limit = 1000;
          } {
            name = "[${account}] Social";
            query = "tag:social";
            limit = 1000;
          } {
            name = "[${account}] Sent";
            query = "tag:sent";
            limit = 1000;
          }
        ];
      };
    };

    # TUI interface
    neomutt = {
      enable = true;
      mailboxType = "imap";
      showDefaultMailbox = false;
    };

    # GUI interface
    astroid = {
      enable = true;
    };
  };
}
