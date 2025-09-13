# Nix-darwin batuhan@su-iyesi home configuration
{
  inputs,
  outputs,
  lib,
  config,
  ...
}: {
  # Be selective what we import since we are on darwin
  imports = [
    # Module imports
    inputs.nixCats.homeManagerModules.default
    inputs.sops-nix.homeManagerModules.sops
    inputs.stylix.homeManagerModules.stylix
    # My modules to load
    #./apps/firefox.nix
    ./apps/kitty.nix
    #./apps/neovim.nix
    ./security/sops.nix
    ./security/ssh.nix
    ./shell/aliases.nix
    ./shell/environment.nix
    ./shell/git.nix
    ./shell/man.nix
    ./shell/tmux.nix
    ./shell/zsh.nix
    ./theming/stylix.nix
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
