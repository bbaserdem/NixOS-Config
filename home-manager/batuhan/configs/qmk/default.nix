# QMK
{
  pkgs,
  config,
  ...
}: {

  # Add qmk to home packages
  home.packages = with pkgs; [
    qmk
  ];

  # Drop a config file, saying that the overlay is in projects
  xdg.configFile."qmk/qmk.ini" = {
    source = (pkgs.formats.ini {}).generate "qmk-config" {
      user = {
        overlay_dir = "${config.home.homeDirectory}/Projects/QMK_Userspace";
      };
    };
  };

  # Drop environment variable defining where the main repo is
  home.sessionVariables."QMK_HOME" = "${config.home.homeDirectory}/Projects/qmk_firmware";

}
