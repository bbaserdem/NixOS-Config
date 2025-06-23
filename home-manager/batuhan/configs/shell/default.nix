# Shell config
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./zsh.nix
    ./direnv.nix
    ./git.nix
    ./man.nix
    ./qmk.nix
    ./pass.nix
    ./tmux.nix
  ];
}
