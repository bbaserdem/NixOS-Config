# batuhan@su-iyesi home configuration
{
  inputs,
  lib,
  config,
  ...
}: {
  # Be selective what we import for now
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ./configs/darwin
  ];

  # Entry point for sops settings
  sops = {
    age.keyFile = "/Users/batuhan/.ssh/batuhan_age_keys.txt";
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      gh-auth = {mode = "0600";};
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
