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
    ./configs/shell/git.nix
    ./configs/shell/man.nix
    ./configs/shell/zsh.nix
    ./configs/shell/tmux.nix
  ];
}
