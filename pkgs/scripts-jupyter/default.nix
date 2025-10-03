# Jupyter-related scripts and utilities
{pkgs}: let
  python = pkgs.python3;

  # Create a Python environment with our scripts
  jupyterScripts = python.withPackages (ps: []);

in pkgs.stdenv.mkDerivation {
  name = "scripts-jupyter";

  src = ./.;

  buildInputs = [ python ];

  installPhase = ''
    mkdir -p $out/bin $out/lib/python $out/share/jupyter

    # Install Python scripts as executables
    cp python_kernel_finder.py $out/bin/python-kernel-finder
    cp kernel_devshell.py $out/bin/kernel-devshell-helper
    cp kernel_json_generator.py $out/bin/kernel-json-generator

    # Install Python modules for importing
    cp python_kernel_finder.py $out/lib/python/
    cp kernel_devshell.py $out/lib/python/
    cp kernel_json_generator.py $out/lib/python/
    cp jupyter_kernel_autoselect.py $out/lib/python/
    cp jupyter_kernel_autoselect.py $out/share/jupyter/

    # Make scripts executable
    chmod +x $out/bin/*

    # Add Python shebang and make them use the right interpreter
    for script in $out/bin/*; do
      sed -i "1s|.*|#!${python}/bin/python3|" "$script"
    done
  '';
}

