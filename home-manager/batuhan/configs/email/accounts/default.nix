# Mail accounts
{
  ...
}: {
  imports = [
    ./wolframite.nix
    ./zbatu.nix
  ];

  # Default account
  accounts.email.accounts.spam.primary = true;
}
