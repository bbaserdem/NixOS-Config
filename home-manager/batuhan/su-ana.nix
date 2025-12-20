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
    inputs.stylix.homeModules.stylix
    # Load syncthing from the main modules directory, it should mirror hm module
    ../../nixos/services/syncthing.nix
    # My modules to load, we do this separately
    ./apps/neovim.nix
    ./apps/kitty.nix
    #./apps/syncthing-darwin.nix
    ./security/keepassxc.nix
    ./security/sops.nix
    ./security/ssh.nix
    ./shell/aliases.nix
    ./shell/applist.nix
    ./shell/bash.nix
    ./shell/direnv.nix
    ./shell/environment.nix
    ./shell/git.nix
    ./shell/man.nix
    ./shell/pnpm.nix
    ./shell/tmux.nix
    ./shell/yazi.nix
    ./shell/zsh.nix
    ./theming/stylix.nix
    ./theming/starship.nix
  ];

  sops.secrets = {
    "syncthing/key" = {
      sopsFile = ./su-ana.secrets.yaml;
    };
    "syncthing/cert" = {
      sopsFile = ./su-ana.secrets.yaml;
    };
  };

  # Syncthing folders
  services.syncthing.settings.folders = {
    media.enable = true;
    work.enable = true;
    sort.enable = false;
    phone.enable = false;
  };

  # Add this directory for mac ports
  home.sessionPath = [
    "/opt/local/bin"
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";

  # Define wallpaper
  myHome.wallpaper.name = "Photo by SpaceX";
}
