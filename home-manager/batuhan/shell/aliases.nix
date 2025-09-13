# Shell config
{...}: {
  # Aliases
  home.shellAliases = {
    ls = "ls --color";
    ll = "ls -l";
    dev = "nix develop --impure -c $SHELL";
    claude = "$HOME/.cc-profile/bin/cc-profile-wrapper";
  };
}
