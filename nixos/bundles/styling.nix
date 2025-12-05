# nixos/bundles/styling.nix
# Module to configure stylix
{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: let
  cfg = config.myNixOS.wallpaper;
  mkAll = lib.lists.foldl (a: b: a && b) true;
in {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  options.myNixOS = {
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
    };
  };

  config = lib.mkMerge [
    {
      stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";

        fonts = {
          monospace = {
            package = pkgs._3270font;
            name = "IBM 3270";
          };
          serif = {
            package = pkgs.caladea;
            name = "Caladea";
          };
          sansSerif = {
            package = pkgs.source-sans-pro;
            name = "Source Sans Pro";
          };
          emoji = {
            package = pkgs.noto-fonts-color-emoji;
            name = "Noto Color Emoji";
          };
        };

        autoEnable = false;
        targets = {
          console.enable = true;
          font-packages.enable = true;
          fontconfig.enable = true;
          gnome-text-editor.enable = true;
          gnome.enable = true;
          grub.enable = false;
          gtk.enable = true;
          gtksourceview.enable = true;
          nixos-icons.enable = true;
          qt.enable = true;
          regreet.enable = true;
        };
      };

      environment.defaultPackages = [pkgs.base16-schemes];
    }
    (
      lib.mkIf (mkAll [
        (cfg.package != null)
        (cfg.directory != null)
        (cfg.name != null)
        (cfg.extension != null)
      ]) {
        stylix.wallpaper = "${cfg.package}/${cfg.directory}/${cfg.name}.${cfg.extension}";
        environment.defaultPackages = [cfg.package];
      }
    )
  ];
}
