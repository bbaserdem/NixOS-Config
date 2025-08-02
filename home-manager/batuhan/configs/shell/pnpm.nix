# QMK
{
  pkgs,
  config,
  ...
}: let
  pnpmHome = "${config.xdg.dataHome}/pnpm";
in {
  home = {
    # Drop environment variables for global pnpm
    sessionVariables."PNPM_HOME" = pnpmHome;
    sessionPath = [pnpmHome];
  };
}
