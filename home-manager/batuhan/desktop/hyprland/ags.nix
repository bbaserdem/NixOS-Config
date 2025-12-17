# ./home-manager/batuhan/desktop/hyprland/ags.nix
# AGS v3 configuration for Hyprland
{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.ags.homeManagerModules.default];

  programs.ags = {
    enable = true;

    # null = don't manage config directory (for development)
    # or set to a path to symlink your config
    configDir = null;

    # additional packages to add to gjs runtime
    extraPackages = with pkgs; [
      # Astal libraries for various functionalities
      inputs.astal.packages.${pkgs.system}.battery
      inputs.astal.packages.${pkgs.system}.bluetooth
      inputs.astal.packages.${pkgs.system}.hyprland
      inputs.astal.packages.${pkgs.system}.network
      inputs.astal.packages.${pkgs.system}.notifd
      inputs.astal.packages.${pkgs.system}.powerprofiles
      inputs.astal.packages.${pkgs.system}.wireplumber

      # Additional runtime executables
      fzf
      brightnessctl
      playerctl
      hyprpicker
    ];
  };

  # Also add the development tools to your environment
  home.packages = with pkgs; [
    # AGS development shell
    inputs.ags.packages.${pkgs.system}.agsFull

    # Astal CLI tools
    inputs.astal.packages.${pkgs.system}.notifd
  ];
}