# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{pkgs ? import <nixpkgs> {}, ...}: {
  # example = pkgs.callPackage ./example { };

  # Scripts for generic usage
  user-audio = pkgs.callPackage ./scripts-audio {};
  user-git = pkgs.callPackage ./scripts-git {};
  user-vifm = pkgs.callPackage ./scripts-vifm {};
  scripts-jupyter = pkgs.callPackage ./scripts-jupyter {};

  # Drivers
  displaylink-driver = import ./drivers/displaylink-driver.nix {inherit pkgs;};
}
