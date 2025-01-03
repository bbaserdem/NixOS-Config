# Configuration test for our google account
{
  config,
  ...
}:
let
  account = "nsfw";
  address = "wolf.x.ramite";
  name = "Wolf Ramite";
  order = 3;
  vmbox = import ./gmailGenInbox.nix account "${address}@gmail.com" order;
in {

  # Need to wait for secrets for imapnotify
  systemd.user.services."imapnotify-${account}".Unit.After = [ "sops-nix.service" ];

  # Main settings for the account
  accounts.email.accounts."${account}" = {

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

    # Folder names (for google with lirr, this apparently is just mail as inbox
    folders = {
      inbox = "mail";
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
        virtualMailboxes = vmbox;
      };
    };

    # TUI interface
    neomutt = {
      enable = true;
      mailboxType = "maildir";
      mailboxName = "[${order}.${account}.0] 📧All Mail";
    };

    # GUI interface
    astroid = {
      enable = true;
    };
  };
}
