# My module that adds custom home-manager options to be defined and referenced
{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.myHome.wallpaper;
  mkAll = lib.lists.foldl (a: b: a && b) true;
in {

  # Custom variables to be referenced to
  options.myHome = {
    wallpaper = {
      name = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "Snow-Capped Mountain";
        description = "Wallpaper name to be used.";
      };
      package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = null;
        example = pkgs.pantheon.elementary-wallpapers;
        description = "Package to draw the wallpapers from.";
      };
      directory = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "share/backgrounds";
        description = "Directory the wallpapers are in.";
      };
      extension = lib.mkOption {
        type = lib.types.enum [
          null
          "jpg"
          "jpeg"
          "png"
          "bmp"
        ];
        default = null;
        example = "jpg";
        description = "Extension used by the wallpaper.";
      };
      path = lib.mkOption {
        type = lib.types.str;
        description = "Path to the wallpaper file";
        readOnly = true;
      };
    };
  };

  config = lib.mkIf (mkAll [
    (cfg.package != null)
    (cfg.directory != null)
    (cfg.name != null)
    (cfg.extension != null)
  ]) {
    myHome.wallpaper.path = "${cfg.package}/${cfg.directory}/${cfg.name}.${cfg.extension}";
  };
}
