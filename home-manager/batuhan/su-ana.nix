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
    inputs.mac-app-util.homeManagerModules.default
    inputs.nixCats.homeManagerModules.default
    inputs.sops-nix.homeManagerModules.sops
    # My modules to load
    ./apps/firefox.nix
    ./apps/neovim.nix
    ./apps/syncthing-darwin.nix
    ./media/mpd.nix
    ./media/ncmpcpp.nix
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

  # Syncthing folders
  services.syncthing.settings.folders = {
    media.enable = true;
    skyfi.enable = true;
    work.enable = false;
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
