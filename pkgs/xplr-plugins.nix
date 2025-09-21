{pkgs ? import <nixpkgs> {}, ...}: let
  inherit (pkgs) fetchFromGitHub fetchFromGitLab stdenv;

  mkXplrPlugin = {name, src}: stdenv.mkDerivation {
    pname = name;
    version = "unstable-${builtins.substring 0 8 src.rev}";
    inherit src;

    installPhase = ''
      mkdir -p $out
      cp -r * $out/
    '';

    meta = {
      description = "XPLR plugin: ${name}";
      homepage = src.meta.homepage or null;
    };
  };
in {
  dual-pane-xplr = mkXplrPlugin {
    name = "dual-pane-xplr";
    src = fetchFromGitHub {
      owner = "sayanarijit";
      repo = "dual-pane.xplr";
      rev = "2c4106c1cc882ac3f832b77a3c72fdce83e17d72"; # main
      hash = "sha256-/b49pDSz1nIFpKmaqdlWmacUzLGfFIHo0oVhFjHEQWY=";
    };
  };
  offline-docs-xplr = mkXplrPlugin {
    name = "offline-docs-xplr";
    src = fetchFromGitHub {
      owner = "sayanarijit";
      repo = "offline-docs.xplr";
      rev = "cba060b5a009696fe1b2ccbdd73d7ba2e2d7b51d"; # main
      hash = "sha256-+ilunEbnPpP8NEhfNlr8rK7fwQhyTHFhsFZnI85TkXk=";
    };
  };
  tree-view-xplr = mkXplrPlugin {
    name = "tree-view-xplr";
    src = fetchFromGitHub {
      owner = "sayanarijit";
      repo = "tree-view.xplr";
      rev = "eeba82a862ca296db253d7319caf730ce1f034c2"; # main
      hash = "sha256-v9KDupi5l3F+Oa5X6pc/Qz9EhaFIrnQK5sckjne/kIU=";
    };
  };
  tri-pane-xplr = mkXplrPlugin {
    name = "tri-pane-xplr";
    src = fetchFromGitHub {
      owner = "sayanarijit";
      repo = "tri-pane.xplr";
      rev = "d90c65eb2bdd182f09db2db8969a99666f90c78b"; # main
      hash = "sha256-repzWTUYZirpBwQ+SEe1Gp1EFMHGG5VONSRS00c995c=";
    };
  };
  wl-clipboard-xplr = mkXplrPlugin {
    name = "wl-clipboard-xplr";
    src = fetchFromGitHub {
      owner = "sayanarijit";
      repo = "wl-clipboard.xplr";
      rev = "a3ffc87460c5c7f560bffea689487ae14b36d9c3"; # main
      hash = "sha256-I4rh5Zks9hiXozBiPDuRdHwW5I7ppzEpQNtirY0Lcks=";
    };
  };
  trash-cli-xplr = mkXplrPlugin {
    name = "trash-cli-xplr";
    src = fetchFromGitHub {
      owner = "sayanarijit";
      repo = "trash-cli.xplr";
      rev = "2c5c8c64ec88c038e2075db3b1c123655dc446fa"; # main
      hash = "sha256-Yb6meF5TTVAL7JugPH/znvHhn588pF5g1luFW8YYA7U=";
    };
  };
  web-devicons-xplr = mkXplrPlugin {
    name = "web-devicons-xplr";
    src = fetchFromGitLab {
      owner = "hartan";
      repo = "web-devicons.xplr";
      rev = "9183a0cc146a29e4f25749463d293be920c6691e"; # main
      hash = "sha256-qzibWL5tOWmXAMaxhUO5jFUdD6k7wsG3Mdhz/elngKQ=";
    };
  };
}
