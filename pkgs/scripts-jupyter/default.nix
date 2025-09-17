# Jupyter-related scripts and utilities
{pkgs}:
pkgs.symlinkJoin {
  name = "scripts-jupyter";
  paths = [
    # Python kernel finder script
    (import ./python-kernel-finder.nix {inherit pkgs;})

    # Jupyter kernel autoselect Python module
    (pkgs.writeTextFile {
      name = "jupyter-kernel-autoselect";
      destination = "/share/jupyter/jupyter_kernel_autoselect.py";
      text = builtins.readFile ./jupyter_kernel_autoselect.py;
    })
  ];

  postBuild = ''
    # Create a convenience symlink for the Python module
    mkdir -p $out/lib/python
    ln -s $out/share/jupyter/jupyter_kernel_autoselect.py $out/lib/python/
  '';
}

