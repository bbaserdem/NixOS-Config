# home-manager/batuhan/desktop/hyprland/shell.nix
# The shell config, using dank material shell
{
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
  ];

  programs.caelestia = {
    enable = true;
    systemd.enable = false;
    settings = {
      bar.status = {
        showBattery = false;
      };
      paths.wallpaperDir = "${config.xdg.userDirs.pictures}/Wallpapers";
    };
    cli = {
      enable = true;
      settings = {
        theme.enableGtk = false;
      };
    };
  };
}
