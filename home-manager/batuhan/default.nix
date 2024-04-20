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

    ./configs/beets
  ];

  # System setup
  home = {
    username = "batuhan";
    homeDirectory = "/home/batuhan";
  };
  xdg = {
    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop =     "${config.home.homeDirectory}/Desktop";
      documents =   "${config.home.homeDirectory}/Media/Documents";
      music =       "${config.home.homeDirectory}/Media/Music";
      pictures =    "${config.home.homeDirectory}/Media/Pictures";
      templates =   "${config.home.homeDirectory}/Media/Templates";
      videos =      "${config.home.homeDirectory}/Media/Videos";
      publicShare = "${config.home.homeDirectory}/Shared/Public";
      download =    "${config.home.homeDirectory}/Sort/Downloads";
      extraConfig = {
        XDG_STAGING_DIR = "${config.home.homeDirectory}/Sort";
        XDG_PHONE_DIR = "${config.home.homeDirectory}/Shared/Android";
      };
    };
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
  home.stateVersion = "23.11";
}
