# Setup the environment
{
  pkgs,
  config,
  ...
}: let
  flakeDir = "${config.home.homeDirectory}/Projects/Nix/NixOS";
in {
  # Local binaries
  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];

  home.sessionVariables = {
    # My flake directory, used with NH as well
    FLAKE = "${flakeDir}";
    NH_FLAKE = "${flakeDir}";
  };
}
