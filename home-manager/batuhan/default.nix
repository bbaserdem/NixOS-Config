# batuhan home-manager config
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  myLib,
  rootPath,
  ...
}: {
  imports = [
    inputs.nix-colors.homeManagerModules.default
    inputs.sops-nix.homeManagerModules.sops

    ./configs/beets
    ./configs/browser
    ./configs/git
    ./configs/keyboard
    ./configs/paths
    ./configs/theming
    ./configs/videoRip
    ./configs/zathura
    ./configs/zsh
  ];

  # System setup
  home = {
    username = "batuhan";
    homeDirectory = "/home/batuhan";
  };

  # User-wide color theme
  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-soft;

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  nixpkgs = {
    # My overlays/etc
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      outputs.overlays.firefox-addon-packages
    ];
    config = {
      allowUnfree = true;    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
