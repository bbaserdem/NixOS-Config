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
    ./pass.nix
    ./pnpm.nix
    ./tmux.nix
    ./vifm.nix
  ];
}
