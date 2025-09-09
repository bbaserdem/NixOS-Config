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

  # Aliases
  home.shellAliases = {
    ls = "ls --color";
    ll = "ls -l";
    dev = "nix develop --impure -c $SHELL";
    claude = "$HOME/.cc-profile/bin/cc-profile-wrapper";
  };
}
