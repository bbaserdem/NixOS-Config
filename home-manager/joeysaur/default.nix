# joeysaur home-manager config
{
  inputs,
  outputs,
  ...
}: {
  imports = [
    # Internal modules
    outputs.nixCats.homeManagerModules.default
    # External modules
    inputs.nix-colors.homeManagerModules.default
    inputs.stylix.homeManagerModules.stylix

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

  # User-wide color theme
  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-macchiato;

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
      outputs.nixCats.overlays.default
      inputs.nur.overlays.default
    ];
    config = {
      allowUnfree = true;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
