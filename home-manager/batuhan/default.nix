# batuhan home-manager config
{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    # External modules
    inputs.nix-index-database.homeModules.nix-index
    # My variables
    outputs.homeManagerModules.userConfig
    # My modules
    ./apps
    ./email
    ./desktop
    ./media
    ./security
    ./shell
    ./theming
  ];

  # System setup
  home = {
    username = "batuhan";
    homeDirectory = "/home/batuhan";
  };

  # Nixpkgs version
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

  # Make all our wallpapers elementary OS wallpapers
  myHome.wallpaper = {
    package = pkgs.pantheon.elementary-wallpapers;
    directory = "share/backgrounds";
    extension = "jpg";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
