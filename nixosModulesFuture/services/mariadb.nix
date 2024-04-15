# Configuring mysql

{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };
}
