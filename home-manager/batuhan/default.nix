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
    ./configs/dconf
    ./configs/direnv
    ./configs/email
    ./configs/firefox
    ./configs/fluidsynth
    ./configs/git
    ./configs/gnome
    ./configs/gnupg
    ./configs/hyprland
    ./configs/keyboard
    ./configs/kitty
    ./configs/man
    ./configs/mimetypes
    ./configs/mpd
    ./configs/mpv
    ./configs/neovim
    ./configs/newsboat
    ./configs/nixshells
    ./configs/nnn
    ./configs/pass
    ./configs/paths
    ./configs/remmina
    ./configs/sops
    ./configs/ssh
    ./configs/texlive
    ./configs/theming
    ./configs/tmux
    ./configs/udiskie
    ./configs/vifm
    ./configs/virt-manager
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
  
  # Entry point for sops settings
  sops = {
    age.keyFile = "/home/batuhan/.ssh/batuhan_age_keys.txt";
    defaultSopsFile = ./secrets.yaml;
  };

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
