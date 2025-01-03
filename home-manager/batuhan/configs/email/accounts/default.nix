# Mail accounts
args@{
  ...
}: {
  imports = [
    # Using the module template to centrally generate google accounts
    ( import ./google-lieer.nix ( args // {
      account = "spam";
      address = "zbatu.bogus";
      name = "Z Batuhan Batu";
      order = "2";
    }))
    ( import ./google-lieer.nix ( args // {
      account = "nsfw";
      address = "wolf.x.ramite";
      name = "Wolf Ramite";
      order = "3";
    }))
  ];

  # Default account
  accounts.email.accounts.spam.primary = true;

  # Add custom queries to notmuch
  programs.notmuch.extraConfig.query = {
    a0-orig = "to:baserdem.batuhan@gmail.com";
    a1-work = "to:baserdemb@gmail.com";
    a2-spam = "to:zbatu.bogus@gmail.com";
    a3-nsfw = "to:wolf.x.ramite@gmail.com";
    f0-mail = "(tag:inbox -tag:promotions -tag:social) OR (tag:inbox and tag:flagged)";
    f1-pers = "tag:personal";
    f2-prom = "tag:promotions";
    f3-socl = "tag:social";
    f4-sent = "tag:sent";
    f5-flag = "tag:flagged";
    f6-arch = "not tag:inbox AND not tag:spam";
  };
}
