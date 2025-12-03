{
  description = "LaTeX development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        texlive = pkgs.texlive.combine {
          inherit (pkgs.texlive)
            scheme-basic
            collection-bibtexextra
            collection-binextra
            collection-context
            collection-fontsextra
            collection-fontsrecommended
            collection-fontutils
            collection-formatsextra
            collection-games
            collection-langenglish
            collection-langgreek
            collection-langother
            collection-latex
            collection-latexextra
            collection-latexrecommended
            collection-luatex
            collection-mathscience
            collection-metapost
            collection-pictures
            collection-plaingeneric
            collection-pstricks
            collection-publishers
            collection-xetex
            algorithms
            cleveref
            latexmk
            cormorantgaramond
            xcharter
            tree-dvips
            maths-symbols
            unicode-math
            nunito
            archivo;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            texlive
            nodejs-slim
            uv
            nodePackages.pnpm
          ];

          shellHook = ''
            echo "LaTeX development environment loaded"
            echo "Available tools:"
            echo "  - texlive (with comprehensive LaTeX packages)"
            echo "  - nodejs-slim"
            echo "  - uv (Python package manager)"
            echo "  - pnpm"
          '';
        };
      });
}