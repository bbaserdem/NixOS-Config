# Package definitions - modular package management
{
  pkgs,
  inputs,
  system,
  uvBoilerplate,
  pythonProject,
  ...
}: let
  inherit (pkgs) lib stdenv callPackage;

  # Import package modules
  pythonPackages = import ./python.nix {
    inherit pkgs uvBoilerplate pythonProject;
  };

  customPackages = import ./custom.nix {
    inherit pkgs lib stdenv;
  };

in {
  # Default package (if needed)
  # default = pythonPackages.template or null;
} 
// pythonPackages  # Python workspace packages
// customPackages  # Custom utility packages
