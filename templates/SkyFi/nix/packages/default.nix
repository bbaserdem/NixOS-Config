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
in
  {
    # Default package (if needed)
    # default = pythonPackages.template or null;
  }
  // pythonPackages
