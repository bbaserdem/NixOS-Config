# Shell config
{...}: {
  imports = [
    # Shell necessities
    ./applist.nix
    ./bash.nix
    ./zsh.nix
    ./aliases.nix
    ./environment.nix
    # Terminal app modules
    ./btop.nix
    ./direnv.nix
    ./man.nix
    ./nnn.nix
    ./pass.nix
    ./pnpm.nix
    ./tmux.nix
    ./vcs.nix
    ./vifm.nix
    ./yazi.nix
  ];
}
