# batuhan@su-iyesi home configuration
{
  lib,
  config,
  ...
}: {
  # Be selective what we import for now
  imports = [
    ./configs/apps/kitty.nix
    ./configs/security/ssh.nix
    ./configs/shell/direnv.nix
    #./configs/shell/git.nix
    ./configs/shell/man.nix
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

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
