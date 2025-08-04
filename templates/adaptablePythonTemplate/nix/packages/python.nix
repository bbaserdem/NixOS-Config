# Python workspace packages
{
  pkgs,
  uvBoilerplate,
  pythonProject,
  ...
}: let
  inherit (pkgs) lib;

  # Create a pure Python package (library package) for workspace packages
  createLibraryPackage = packageName:
    if uvBoilerplate.pythonSet ? ${packageName}
    then {
      ${packageName} = uvBoilerplate.pythonSet.${packageName};
    }
    else {};

  # Create a package that could be either library or executable based on whether it has binaries
  createWorkspacePackage = packageName:
    if uvBoilerplate.pythonSet ? ${packageName}
    then 
      # Check if the package has executables in its bin directory
      if builtins.pathExists "${uvBoilerplate.pythonSet.${packageName}}/bin"
      then createExecutablePackage packageName  # Has scripts - create executable wrapper
      else createLibraryPackage packageName     # No scripts - pure library package
    else {};

  # Create a wrapper package with executable for packages that have scripts
  createExecutablePackage = packageName:
    if uvBoilerplate.pythonSet ? ${packageName}
    then {
      ${packageName} = pkgs.stdenv.mkDerivation {
        name = "${packageName}-${uvBoilerplate.pythonSet.${packageName}.version}";
        
        # Create a minimal package with wrapped executables
        buildInputs = [ uvBoilerplate.pythonSet.${packageName} ];
        
        unpackPhase = "true"; # No source to unpack
        
        installPhase = ''
          mkdir -p $out/bin
          
          # Copy and wrap all executables from the source package
          if [ -d "${uvBoilerplate.pythonSet.${packageName}}/bin" ]; then
            for exe in "${uvBoilerplate.pythonSet.${packageName}}/bin"/*; do
              if [ -f "$exe" ] && [ -x "$exe" ]; then
                exe_name=$(basename "$exe")
                
                # Create a wrapper script that sets up PYTHONPATH
                cat > "$out/bin/$exe_name" << EOF
          #!/usr/bin/env bash
          export PYTHONPATH="${uvBoilerplate.pythonSet.${packageName}}/lib/python3.13/site-packages:\$PYTHONPATH"
          exec "$exe" "\$@"
          EOF
                
                chmod +x "$out/bin/$exe_name"
              fi
            done
          fi
          
          # If no executables found but this is the main project, create default wrapper
          if [ ! -d "${uvBoilerplate.pythonSet.${packageName}}/bin" ] && [ "${packageName}" = "${pythonProject.projectName}" ]; then
            cat > $out/bin/${packageName} << EOF
          #!/usr/bin/env bash
          export PYTHONPATH="${uvBoilerplate.pythonSet.${packageName}}/lib/python3.13/site-packages:\$PYTHONPATH"
          exec ${uvBoilerplate.python}/bin/python -m ${packageName}.main "\$@"
          EOF
            
            chmod +x $out/bin/${packageName}
          fi
        '';
        
        meta = {
          description = "${packageName} Python project";
          # Set mainProgram to the first executable found, or fallback to package name
          mainProgram = 
            if builtins.pathExists "${uvBoilerplate.pythonSet.${packageName}}/bin"
            then builtins.head (builtins.attrNames (builtins.readDir "${uvBoilerplate.pythonSet.${packageName}}/bin"))
            else packageName;
        };
      };
    }
    else {};

  # Get all workspace package names
  allWorkspacePackages = 
    (if pythonProject.emptyRoot then [] else [pythonProject.projectName])
    ++ (map (ws: ws.projectName) pythonProject.workspaces);

  # Create packages for all workspace packages
  # Main project gets executable wrapper, workspace packages get library packages
  mainProjectPackages = 
    if pythonProject.emptyRoot then {} 
    else createExecutablePackage pythonProject.projectName;

  workspacePackages = lib.foldl' (acc: packageName: 
    acc // (createWorkspacePackage packageName)
  ) {} (map (ws: ws.projectName) pythonProject.workspaces);

in mainProjectPackages // workspacePackages
