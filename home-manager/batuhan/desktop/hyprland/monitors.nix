# ./home-manager/batuhan/desktop/hyprland/monitors.nix
# Dynamic monitor layout using kanshi
{
  pkgs,
  lib,
  inputs,
  ...
}: {
  services.kanshi = {
    #enable = true;

    # All possible monitors
    settings = [
      {
        output = {
          criteria = "";
        };
      }
    ];

    profiles = {
      "Yel-Ana" = {
        name = "Yel-Ana (Default)";
        outputs = [
          {}
        ];
      };
    };
  };
}
