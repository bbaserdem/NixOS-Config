# QMK
{
  pkgs,
  config,
  ...
}: let
  pnpmHome = "${config.xdg.dataHome}/pnpm";
in {
  home = {
    # Enable pnpm
    packages = with pkgs; [
      pnpm
      nodejs-slim
    ];
    # Drop environment variables
    sessionVariables."PNPM_HOME" = pnpmHome;
    sessionPath = [
      pnpmHome
    ];
  };
}
