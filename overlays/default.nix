# This file defines overlays
# Taken from the stater config here;
# https://github.com/Misterio77/nix-starter-configs

{
  inputs,
  myLib,
  ...
}: with myLib; {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs {pkgs = final;};

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # Standalone version of Nerd Fonts 
    nerdfont-standalone = prev.nerdfonts.override {
      fonts = [ "NerdFontsSymbolsOnly" ];
    };
    # Create yt-dlp aliases for overrides
    yt-dlp = prev.yt-dlp.override { withAlias = true; };
    # Make NNN use nerdfont symbols
    nnn = prev.nnn.override { withNerdIcons = true; };
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
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

  # Will make firefox addons available through pkgs.firefox-addons
  # and should make unfree packages available.
  firefox-addon-packages = final: _prev: {
    firefox-addons = import inputs.firefox-addons {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
