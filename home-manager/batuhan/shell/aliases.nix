# Shell config
{...}: {
  # Aliases
  home.shellAliases = {
    ls = "ls --color";
    ll = "ls -l";
    dev = "nix develop --impure -c $SHELL";
    claude-cc = "$HOME/.cc-profile/bin/cc-profile-wrapper";
    cd-flake = "cd \${FLAKE}";
  };
}
