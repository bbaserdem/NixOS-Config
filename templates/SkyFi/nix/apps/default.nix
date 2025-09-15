# Application definitions - modular app management
{
  pkgs,
  inputs,
  system,
  uvBoilerplate,
  pythonProject,
  outputs,
  ...
}: let
  inherit (pkgs) lib;

  # Import app modules
  pythonApps = import ./python.nix {
    inherit pkgs uvBoilerplate pythonProject outputs;
  };
in
  {}
  // pythonApps
# Python workspace applications

