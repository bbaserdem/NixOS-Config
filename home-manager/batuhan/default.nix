# batuhan home-manager config
{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    # External imports
    inputs.ags.homeManagerModules.default
    inputs.nixcord.homeManagerModules.nixcord
    #inputs.plasma-manager.homeManagerModules.plasma-manager
    inputs.sops-nix.homeManagerModules.sops
    inputs.stylix.homeManagerModules.stylix
    # My nixCats
    outputs.homeManagerModules.nixCats.default
    # My variables
    outputs.homeManagerModules.userConfig

    ./configs/apps
    ./configs/autorandr
    ./configs/beets
    ./configs/btop
    ./configs/calendar
    ./configs/direnv
    ./configs/discord
    ./configs/email
    ./configs/firefox
    ./configs/fluidsynth
    ./configs/git
    ./configs/gnome
    ./configs/gnupg
    #./configs/hyprland
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
    ./configs/qmk
    ./configs/remmina
    ./configs/shell
    ./configs/sops
    ./configs/ssh
    ./configs/style
    ./configs/syncthing
    ./configs/texlive
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

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Entry point for sops settings
  sops = {
    age.keyFile = "/home/batuhan/.ssh/batuhan_age_keys.txt";
    defaultSopsFile = ./secrets.yaml;
  };

  # Make all our wallpapers elementary OS wallpapers
  myHome.wallpaper = {
    package = pkgs.pantheon.elementary-wallpapers;
    directory = "share/backgrounds";
    extension = "jpg";
  };

  nixpkgs = {
    # My overlays
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      outputs.overlays.nixCats.default
      inputs.nur.overlays.default
    ];
    config = {
      allowUnfree = true;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
