# This file defines overlays
# Taken from the stater config here;
# https://github.com/Misterio77/nix-starter-configs

{
  inputs,
  myLib,
  config,
  ...
}: with myLib; {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs {pkgs = final;};

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
    #sleek-grub-theme = final.sleek-grub-theme.overrideAttr {
    #  #withStyle = config.myNixOS.sharedSettings.grubTheme;
    #  withStyle = "bigSur";
    #};
    # sonarr = final.unstable.sonarr;
    # radarr = final.unstable.radarr.overrideAttrs (oldAttrs: rec {
    #   version = "4.4.2.6956";
    #   src = prev.fetchurl {
    #     url = "https://github.com/Radarr/Radarr/releases/download/v${version}/Radarr.develop.${version}.linux-core-x64.tar.gz";
    #     sha256 = "sha256-DVVBJC7gGjlF9S3KI0+9kh4EzDEoWsC2jJxD8khbN2c=";
    #   };
    # });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
