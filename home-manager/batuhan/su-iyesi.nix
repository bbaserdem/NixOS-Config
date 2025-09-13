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
    #inputs.nixCats.homeManagerModules.default
    inputs.sops-nix.homeManagerModules.sops
    inputs.stylix.darwinModules.stylix
    # My modules to load
    ./apps/firefox.nix
    ./apps/kitty.nix
    #./apps/neovim.nix
    ./security/sops.nix
    ./security/ssh.nix
    ./shell/git.nix
    ./shell/man.nix
    ./shell/tmux.nix
    ./shell/zsh.nix
    ./theming/stylix.nix
  ];

  # Nixpkgs version
  nixpkgs = {
    overlays = [
      # My overlays
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      # External overlays
      inputs.nur.overlays.default
    ];
    config = {
      allowUnfree = true;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
