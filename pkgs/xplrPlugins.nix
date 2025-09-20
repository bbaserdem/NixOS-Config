{pkgs ? import <nixpkgs> {}, ...}: {
  dual-pane-xplr = pkgs.fetchFromGitHub {
    owner = "sayanarijit";
    repo = "dual-pane.xplr";
    rev = "2c4106c1cc882ac3f832b77a3c72fdce83e17d72";
    hash = "sha256-0000000000000000000000000000000000000000000=";
  };
  offline-docs-xplr = pkgs.fetchFromGitHub {
    owner = "sayanarijit";
    repo = "offline-docs.xplr";
    rev = "cba060b5a009696fe1b2ccbdd73d7ba2e2d7b51d";
    hash = "sha256-0000000000000000000000000000000000000000000=";
  };
  tree-view-xplr = pkgs.fetchFromGitHub {
    owner = "sayanarijit";
    repo = "tree-view.xplr";
    rev = "eeba82a862ca296db253d7319caf730ce1f034c2";
    hash = "sha256-0000000000000000000000000000000000000000000=";
  };
  tri-pane-xplr = pkgs.fetchFromGitHub {
    owner = "sayanarijit";
    repo = "tri-pane.xplr";
    rev = "d90c65eb2bdd182f09db2db8969a99666f90c78b";
    hash = "sha256-0000000000000000000000000000000000000000000=";
  };
  wl-clipboard-xplr = pkgs.fetchFromGitHub {
    owner = "sayanarijit";
    repo = "wl-clipboard.xplr";
    rev = "a3ffc87460c5c7f560bffea689487ae14b36d9c3";
    hash = "sha256-0000000000000000000000000000000000000000000=";
  };
  trash-cli-xplr = pkgs.fetchFromGitHub {
    owner = "sayanarijit";
    repo = "trash-cli.xplr";
    rev = "2c5c8c64ec88c038e2075db3b1c123655dc446fa";
    hash = "sha256-0000000000000000000000000000000000000000000=";
  };
  web-devicons-xplr = pkgs.fetchFromGitLab {
    owner = "hartan";
    repo = "web-devicons.xplr";
    rev = "9183a0cc146a29e4f25749463d293be920c6691e";
    hash = "sha256-0000000000000000000000000000000000000000000=";
  };
}
