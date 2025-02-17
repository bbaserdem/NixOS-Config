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
    inputs.nixCats.homeManagerModules.default
    inputs.nixcord.homeManagerModules.nixcord
    #inputs.plasma-manager.homeManagerModules.plasma-manager
    inputs.sops-nix.homeManagerModules.sops
    inputs.stylix.homeManagerModules.stylix
    # My variables
    outputs.homeManagerModules.userConfig

    ./configs/apps
    ./configs/autorandr
    ./configs/calendar
    ./configs/direnv
    ./configs/discord
    ./configs/email
    ./configs/git
    ./configs/gnome
    ./configs/gnupg
    #./configs/hyprland
    ./configs/keyboard
    ./configs/man
    ./configs/media
    ./configs/mimetypes
    ./configs/nixshells
    ./configs/nnn
    ./configs/pass
    ./configs/paths
    #./configs/plasma
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
    overlays = [
      # My overlays
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      # External overlays
      inputs.nixCats.overlays.default
      inputs.nur.overlays.default
    ];
    config = {
      allowUnfree = true;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
