# joeysaur home-manager config
{
  inputs,
  outputs,
  ...
}: {
  imports = [
    # External imports
    inputs.nix-colors.homeManagerModules.default

    ./configs/apps
    ./configs/firefox
    ./configs/git
    ./configs/gnome
    ./configs/gnupg
    ./configs/keyboard
    ./configs/kitty
    ./configs/mimetypes
    ./configs/neovim
    ./configs/paths
    ./configs/ssh
    ./configs/texlive
    ./configs/theming
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
      inputs.nur.overlay
    ];
    config = {
      allowUnfree = true;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}