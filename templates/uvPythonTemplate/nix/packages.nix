{
  pkgs,
  inputs,
  uvBoilerplate,
  projectName,
  ...
}: let
  inherit (pkgs) lib stdenv testers callPackage;
in {
  # Default lapack image
  #default = callPackage lapackDerivation {};
  # Our python project projects here
  ${projectName} =
    uvBoilerplate.pythonSet.mkVirtualEnv
    "${projectName}-env"
    uvBoilerplate.workspace.deps.default;
}
