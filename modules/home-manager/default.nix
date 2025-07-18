# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  inputs,
  outputs,
  ...
}: {
  # List your module files here
  # my-module = import ./my-module.nix;
  default = {};

  # User config variables
  userConfig = import ./userConfig.nix;

  # Powerlevel10k module
  powerlevel10k = import ./powerlevel10k.nix;

  # Cursor ai fix for the weird freezing bug v1.2
  code-cursor = import ./code-cursor.nix;

  # Cursor ai fix for the weird freezing bug v1.2
  claude-code = import ./claude-code.nix;
}
