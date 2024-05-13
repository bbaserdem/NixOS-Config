# batuhan home-manager config
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # External imports
    inputs.ags.homeManagerModules.default
    inputs.nix-colors.homeManagerModules.default
    inputs.sops-nix.homeManagerModules.sops

    ./configs/apps
    ./configs/autorandr
    ./configs/beets
    ./configs/btop
    ./configs/calendar
    ./configs/firefox
    ./configs/fluidsynth
    ./configs/git
    ./configs/gnupg
    ./configs/hyprland
    ./configs/keyboard
    ./configs/kitty
    ./configs/mimetypes
    ./configs/mpd
    ./configs/mpv
    ./configs/neomutt
    ./configs/neovim
    ./configs/newsboat
    ./configs/nixshells
    ./configs/nnn
    ./configs/pass
    ./configs/paths
    # ./configs/remmina on unstable branch
    ./configs/sops
    ./configs/syncthing
    ./configs/texlive
    ./configs/theming
    ./configs/tmux
    ./configs/udiskie
    ./configs/yt-dlp
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
    # My overlays
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      inputs.nur.overlay
    ];
    config = {
      allowUnfree = true;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
