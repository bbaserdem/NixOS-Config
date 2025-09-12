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
    ./configs/apps/kitty.nix
    ./configs/security/sops.nix
    ./configs/security/ssh.nix
    ./configs/shell/direnv.nix
    ./configs/shell/git.nix
    ./configs/shell/man.nix
    ./configs/paths
    ./configs/shell/zsh.nix
    ./configs/shell/tmux.nix
  ];

  # Entry point for sops settings
  # sops = {
  #   age.keyFile = "/home/batuhan/.ssh/batuhan_age_keys.txt";
  #   defaultSopsFile = ./secrets.yaml;
  #   secrets = {
  #     gh-auth = {mode = "0600";};
  #   };
  # };

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
