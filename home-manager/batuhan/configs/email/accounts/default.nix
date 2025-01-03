# Mail accounts
args@{
  ...
}: {
  imports = [
    ./zbatu.nix
    # Using the module template to centrally generate google accounts
    ( import ./google-lieer.nix ( args // {
      account = "nsfw";
      address = "wolf.x.ramite";
      name = "Wolf Ramite";
      order = "3";
    }))
  ];

  # Default account
  accounts.email.accounts.spam.primary = true;
}
