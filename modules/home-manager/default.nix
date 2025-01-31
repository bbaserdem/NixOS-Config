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

  # My nixCats home modules
  nixCats = (import ../../nixCats {inherit inputs outputs;}).homeManagerModules;
}
