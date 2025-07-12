# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{pkgs ? import <nixpkgs> {}, ...}: {
  # example = pkgs.callPackage ./example { };

  # Audio related scripts, this is already a derivation
  user-audio = pkgs.callPackage ./audio-scripts {};

  # System related scripts
  user-script-vifm-visualpreview = pkgs.callPackage ./userscripts/vifm-visualpreview.nix {};
  user-script-vifm-preview = pkgs.callPackage ./userscripts/vifm-preview.nix {};

  # Drivers
  displaylink-driver = import ./drivers/displaylink-driver.nix {inherit pkgs;};
}
