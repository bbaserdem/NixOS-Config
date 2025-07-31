# QMK
{
  pkgs,
  config,
  ...
}: let
  pnpmHome = "${config.xdg.dataHome}/pnpm";
in {
  # Add qmk to home packages
  home.packages = with pkgs; [
    pnpm
    nodejs-slim_24 # Node w/out npm
  ];

  # Drop environment variables
  home = {
    sessionVariables."PNPM_HOME" = pnpmHome;
    sessionPath = [
      pnpmHome
    ];
  };
}
