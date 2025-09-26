# Bundling nix related software
{
  pkgs,
  inputs,
  lib,
  arch,
  ...
}: (
  lib.mkMerge [
    {
      # Package manager config
      nix = {
        gc = {
          automatic = true;
          options = "--delete-older-than 60d";
        };
        nixPath = ["nixpkgs=${inputs.nixpkgs}"];
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
            "pipe-operators"
          ];
          auto-optimise-store = true;
          # For dev related things
          keep-outputs = true;
          keep-derivations = true;
        };
      };

      # Nix helper utilities
      environment.systemPackages = with pkgs; [
        nh
        nix-output-monitor
        nvd
        sops
        nix-index
      ];
    }
    (lib.mkIf (lib.hasSuffix "-linux" arch) (
      lib.optionalAttrs (lib.hasSuffix "-linux" arch) {
        programs = {
          # Use nix-index to find execs
          command-not-found.enable = true;
          # Linux-specific configuration
          nix-ld.enable = true;
        };
        # Time out the gc
        nix.gc.dates = "weekly";
      }
    ))
    (lib.mkIf (lib.hasSuffix "-darwin" arch) (
      lib.optionalAttrs (lib.hasSuffix "-darwin" arch) {
        # Darwin-specific configuration
        nix = {
          enable = false;
          gc.interval = [
            {
              Hour = 3;
              Minute = 15;
              Weekday = 7;
            }
          ];
        };
      }
    ))
  ]
)
