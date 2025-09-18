# Nix-darwin batuhan@su-ana home configuration
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
    outputs.homeManagerModules.userConfig
    inputs.nixCats.homeManagerModules.default
    inputs.sops-nix.homeManagerModules.sops
    # My modules to load
    # ./apps/firefox.nix
    ./apps/kitty.nix
    ./apps/neovim.nix
    # ./desktop/aerospace.nix
    ./media/mpd.nix
    ./media/ncmpcpp.nix
    ./security/sops.nix
    ./security/ssh.nix
    ./shell/aliases.nix
    ./shell/bash.nix
    ./shell/direnv.nix
    ./shell/environment.nix
    ./shell/git.nix
    ./shell/man.nix
    ./shell/pnpm.nix
    ./shell/tmux.nix
    ./shell/zsh.nix
    ./theming/stylix.nix
    ./theming/starship.nix
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";

  # Define wallpaper
  myHome.wallpaper.name = "Photo by SpaceX";
}
