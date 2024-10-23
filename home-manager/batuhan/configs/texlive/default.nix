# Texlive
{pkgs, ...}: {
  programs.texlive = {
    enable = true;
    packageSet = pkgs.texlive;
    extraPackages = tpkgs: {
      inherit
        (tpkgs)
        collection-basic
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
        ;
    };
  };
}
