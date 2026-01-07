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

        fonts = with pkgs; {
          monospace = {
            package = _3270font;
            name = "IBM 3270";
          };
          serif = {
            package = caladea;
            name = "Caladea";
          };
          sansSerif = {
            package = source-sans-pro;
            name = "Source Sans Pro";
          };
          emoji = {
            package = noto-fonts-color-emoji;
            name = "Noto Color Emoji";
          };
        };

        icons = {
          enable = true;
          package = pkgs.qogir-icon-theme;
          dark = "Qogir-Dark";
          light = "Qogir";
        };

        cursor = {
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Ice";
          size = 24;
        };

        opacity = {
          applications = 1.0;
          desktop = 0.9;
          popups = 0.9;
          terminal = 0.9;
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

      environment.defaultPackages = with pkgs; [
        base16-schemes
        # Fonts
        nerd-fonts.symbols-only
        noto-fonts-color-emoji
        _3270font # Monospace
        fira-code # Monospace with ligatures
        liberation_ttf # Windows compat.
        caladea #   Office fonts alternative
        carlito #   Calibri/georgia alternative
        inconsolata # Monospace font, for prints
        iosevka # Monospace font, for terminal mostly
        jetbrains-mono # Readable monospace font
        victor-mono # Nice monospace font with ligatures
        noto-fonts
        source-serif-pro
        source-sans-pro
        curie # Bitmap fonts
        tamsyn
      ];
    }
    (
      lib.mkIf (mkAll [
        (cfg.package != null)
        (cfg.directory != null)
        (cfg.name != null)
        (cfg.extension != null)
      ]) {
        stylix.image = "${cfg.package}/${cfg.directory}/${cfg.name}.${cfg.extension}";
        environment.defaultPackages = [cfg.package];
      }
    )
  ];
}
