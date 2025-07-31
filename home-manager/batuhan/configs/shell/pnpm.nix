# QMK
{
  pkgs,
  config,
  ...
}: let
  pnpmHome = "${config.xdg.dataHome}/pnpm";
in {
  # Enable pnpm
  programs.pnpm.enable = true;

  # Drop environment variables
  home = {
    sessionVariables."PNPM_HOME" = pnpmHome;
    sessionPath = [
      pnpmHome
    ];
  };
}
