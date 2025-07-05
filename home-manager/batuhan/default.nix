# batuhan home-manager config
{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    # My variables
    outputs.homeManagerModules.userConfig
    # My modules
    ./configs/apps
    ./configs/autorandr
    ./configs/calendar
    ./configs/email
    #./configs/gnome
    #./configs/hyprland
    ./configs/keyboard
    ./configs/media
    ./configs/mimetypes
    ./configs/nnn
    ./configs/paths
    #./configs/plasma
    ./configs/remmina
    ./configs/security
    ./configs/shell
    ./configs/style
    ./configs/texlive
    ./configs/udiskie
    ./configs/vifm
    ./configs/virt-manager
    ./configs/yt-dlp
  ];

  # System setup
  home = {
    username = "batuhan";
    homeDirectory = "/home/batuhan";
  };
  nixpkgs = {
    overlays = [
      # My overlays
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      # External overlays
      inputs.nur.overlays.default
    ];
    config = {
      allowUnfree = true;
    };
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Entry point for sops settings
  sops = {
    age.keyFile = "/home/batuhan/.ssh/batuhan_age_keys.txt";
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      openai-apk = {
        mode = "0600";
      };
    };
  };

  # Make all our wallpapers elementary OS wallpapers
  myHome.wallpaper = {
    package = pkgs.pantheon.elementary-wallpapers;
    directory = "share/backgrounds";
    extension = "jpg";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
