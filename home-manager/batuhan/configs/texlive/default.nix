# Texlive
{
  pkgs,
  ...
}: {
  programs.texlive = {
    enable = true;
    packageSet = pkgs.texlive.combined.scheme-full;
  };
}
