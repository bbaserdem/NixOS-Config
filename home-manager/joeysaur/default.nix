# joeysaur home-manager config
{
  inputs,
  outputs,
  ...
}: {
  imports = [
    # Internal modules
    # External modules
    inputs.stylix.homeManagerModules.stylix
    outputs.nixCats.homeManagerModules.default

    ./configs/apps
    ./configs/dconf
    ./configs/git
    ./configs/gnome
    ./configs/gnupg
    ./configs/keyboard
    ./configs/mpd
    ./configs/paths
    ./configs/ssh
    ./configs/stylix
    ./configs/texlive
    ./configs/udiskie
    ./configs/yt-dlp
    ./configs/zsh
  ];

  # System setup
  home = {
    username = "joeysaur";
    homeDirectory = "/home/joeysaur";
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

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
