# Main theming stuff
{pkgs, ...}: let
  nfToml = builtins.readFile "${pkgs.starship}/share/starship/presets/nerd-font-symbols.toml";
  nfSettings = builtins.fromTOML nfToml;
in {
  programs.starship = {
    enable = true;
    enableInteractive = true;
    settings =
      nfSettings
      // {
        follow_symlinks = true;
      };
  };
}
