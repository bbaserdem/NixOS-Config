# Nix-darwin batuhan@su-iyesi home configuration
{
  inputs,
  outputs,
  lib,
  config,
  ...
}: {
  # Be selective what we import since we are on darwin
  imports = [
    # Module imports
    inputs.nixCats.homeManagerModules.default
    inputs.stylix.darwinModules.stylix
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
