# home-manager/batuhan/desktop/hyprland/shell.nix
# The shell config, using dank material shell
{inputs, ...}: {
  imports = [
    inputs.dms.homeModules.dankMaterialShell.default
  ];

  programs.dankMaterialShell = {
    enable = true;

    systemd = {
      enable = true;
      restartIfChanged = true;
    };
  };
}
