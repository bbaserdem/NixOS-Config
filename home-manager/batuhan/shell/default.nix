# Shell config
{...}: {
  imports = [
    # Shell necessities
    ./applist.nix
    ./zsh.nix
    ./aliases.nix
    ./environment.nix
    # Terminal app modules
    ./btop.nix
    ./direnv.nix
    ./git.nix
    ./man.nix
    ./nnn.nix
    ./pass.nix
    ./pnpm.nix
    ./tmux.nix
    ./vifm.nix
  ];
}
