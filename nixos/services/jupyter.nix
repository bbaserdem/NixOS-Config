# nixos/services/jupyter.nix
# Jupyter Lab server setup
{
  config,
  lib,
  pkgs,
  ...
}: let
  startDir = "/home/${config.myNixOS.userName}/Projects";
in {
  # Enable Jupyter service using built-in NixOS module
  services.jupyter = {
    enable = true;

    # Use JupyterLab instead of classic notebook
    command = "jupyter-lab"; # This ensures we use JupyterLab

    # Network configuration
    ip = "127.0.0.1"; # Allow internal traffic only
    port = 8888;

    # Authentication - Traefik handles this, so use empty password
    password = "''"; # Empty password since Traefik provides auth

    # Working directory
    notebookDir = startDir;

    # User configuration
    user = "compute";
    group = "users";

    # Python package for Jupyter with essential packages
    package = pkgs.python313.withPackages (ps:
      with ps; [
        jupyterlab # JupyterLab interface
        ipykernel # Python kernel
        ipywidgets # Interactive widgets

        # Essential scientific packages
        numpy
        matplotlib
        pandas
      ]);

    # Additional Jupyter configuration
    notebookConfig = ''
      # JupyterLab specific configuration
      c.ServerApp.allow_remote_access = False
      c.ServerApp.disable_check_xsrf = True
      c.ServerApp.open_browser = False

      # Resource limits
      c.ServerApp.max_buffer_size = 2147483648 # 2GB
      c.ServerApp.max_body_size = 2147483648   # 2GB for large file uploads

      # Kernel management
      c.MappingKernelManager.cull_idle_timeout = 7200    # 2 hours
      c.MappingKernelManager.cull_interval = 300         # Check every 5 minutes
      c.MappingKernelManager.cull_connected = False      # Don't cull connected kernels

      # Working directory
      c.ServerApp.root_dir = '${startDir}'
    '';
  };
}
