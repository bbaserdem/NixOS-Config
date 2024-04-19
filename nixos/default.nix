# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  pkgs,
  config,
  lib,
  inputs,
  outputs,
  myLib,
  ...
}: let
  # We use the myNixOS field to populate self options
  cfg = config.myNixOS;
    # Grab all modules in ./features and add enables to them
  features =
    myLib.extendModules
    (name: {
      extraOptions = {
        myNixOS.${name}.enable = lib.mkEnableOption "Enable my ${name} configuration";
      };
      configExtension = config: (lib.mkIf cfg.${name}.enable config);
    })
    (myLib.filesIn ./features);
  # Grab all modules in ./bundles and add enables to them
  bundles =
    myLib.extendModules
    (name: {
      extraOptions = {
        myNixOS.bundles.${name}.enable = lib.mkEnableOption "Enable my ${name} module bundle";
      };
      configExtension = config: (lib.mkIf cfg.bundles.${name}.enable config);
    })
    (myLib.filesIn ./bundles);
  # GRab all modules in services and add enables to them
  services =
    myLib.extendModules
    (name: {
      extraOptions = {
        myNixOS.services.${name}.enable = lib.mkEnableOption "Enable my ${name} service";
      };
      configExtension = config: (lib.mkIf cfg.services.${name}.enable config);
    })
    (myLib.filesIn ./services);

in {
  # Import bunch of files, and home-manager module
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ]
  ++ features
  ++ bundles
  ++ services;

  options.myNixOS = {
    sharedSettings = {
      hyprland.enable = lib.mkEnableOption "Enable Hyprland";
    };
  };

}
