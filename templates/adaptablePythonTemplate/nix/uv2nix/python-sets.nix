# Python package set construction
{
  inputs,
  pkgs,
  lib,
  stdenv,
  pythonProject,
  python,
  overlayData,
  workspaceData,
  ...
}: let
  inherit (inputs) pyproject-nix pyproject-build-systems;
  inherit (overlayData) overlay pyprojectOverrides editableOverlay;

  # Import workspace overrides for test support
  workspaceOverrides = import ./workspace-overrides.nix {
    inherit lib stdenv pythonProject;
  };

  # Base python package set
  baseSet = pkgs.callPackage pyproject-nix.build.packages {inherit python;};

  # Construct package set with all overlays
  pythonSet = baseSet.overrideScope (
    lib.composeManyExtensions [
      pyproject-build-systems.overlays.default
      overlay
      pyprojectOverrides
    ]
  );

  # Create editable fixups for all workspace packages
  editableFixups = final: prev: let
    # Get all package names from the python project config
    allPackageNames =
      (
        if pythonProject.emptyRoot
        then []
        else [pythonProject.projectName]
      )
      ++ (map (ws: ws.projectName) pythonProject.workspaces);

    # Create fixup for a single package
    makeEditableFixup = pkgName: {
      name = pkgName;
      value = prev.${pkgName}.overrideAttrs (old: {
        # Add editables to nativeBuildInputs for hatchling
        nativeBuildInputs =
          old.nativeBuildInputs
          ++ final.resolveBuildSystem {
            editables = [];
          };
      });
    };

    # Apply fixup to all packages that exist in prev
    packageFixups = lib.listToAttrs (
      lib.filter
      (x: prev ? ${x.name})
      (map makeEditableFixup allPackageNames)
    );
  in
    packageFixups;

  # Editable python set with fixups for the main package
  editablePythonSet = pythonSet.overrideScope (
    lib.composeManyExtensions [
      editableOverlay
      editableFixups
    ]
  );
in {
  inherit
    baseSet
    pythonSet
    editablePythonSet
    ;
}
