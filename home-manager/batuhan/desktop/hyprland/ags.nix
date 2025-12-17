# ./home-manager/batuhan/desktop/hyprland/ags.nix
# AGS v3 configuration for Hyprland
{
  pkgs,
  inputs,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
in {
  imports = [inputs.ags.homeManagerModules.default];

  programs.ags = {
    enable = true;

    # null = don't manage config directory (for development)
    # or set to a path to symlink your config
    configDir = null;

    # additional packages to add to gjs runtime
    extraPackages = with pkgs; [
      # Astal libraries for various functionalities
      inputs.astal.packages.${system}.battery
      inputs.astal.packages.${system}.bluetooth
      inputs.astal.packages.${system}.hyprland
      inputs.astal.packages.${system}.network
      inputs.astal.packages.${system}.notifd
      inputs.astal.packages.${system}.powerprofiles
      inputs.astal.packages.${system}.wireplumber

      # Additional runtime executables
      fzf
      brightnessctl
      playerctl
      hyprpicker
    ];
  };

  # Development tools (separate from runtime AGS)
  home.packages = [
    # Astal CLI tools
    inputs.astal.packages.${system}.notifd
  ];
}

