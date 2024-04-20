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
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Other flakes
    inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    ./configs/beets
  ];

  # TODO: Set your usernam  home = {
    username = "batuhan";
    homeDirectory = "/home/batuhan";
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  nixpkgs = {
    # You can add overlays here
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      #allowUnfreePredicate = _: true;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
