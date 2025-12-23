# home-manager/batuhan/desktop/hyprland/shell.nix
# The shell config, using dank material shell
{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.dms.homeModules.dankMaterialShell.default
  ];

  programs.dankMaterialShell = {
    enable = true;
  };
}
