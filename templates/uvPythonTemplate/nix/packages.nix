{
  pkgs,
  inputs,
  uvBoilerplate,
  projectName,
  ...
}: let
  inherit (pkgs) lib stdenv testers callPackage;

  # Create packages for all workspaces that have executable outputs
  pythonPackages = lib.listToAttrs (
    map (ws: {
      name = ws.name;
      value =
        uvBoilerplate.pythonSet.mkVirtualEnv
        "${ws.name}-env"
        uvBoilerplate.workspaces.${ws.name}.deps.default;
    }) (lib.filter (ws: uvBoilerplate.pythonSet ? ${ws.name}) uvBoilerplate.allWorkspaces)
  );
in
  {
    # Default image
    #default = callPackage derivation {};
  }
  // pythonPackages
