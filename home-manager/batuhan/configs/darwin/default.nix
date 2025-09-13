# Setup macos things
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./editor.nix
    ./git.nix
    ./kitty.nix
    ./man.nix
    ./tmux.nix
    ./zsh.nix
    ./../security/ssh.nix
  ];
}
