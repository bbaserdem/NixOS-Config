# nixos/services/jupyter.nix
# Jupyter Lab server setup
{
  config,
  lib,
  pkgs,
  ...
}: {
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
    notebookDir = "/home/${config.myNixOS.user}/Projects";

    # User configuration
    user = "compute";
    group = "users";

    # Python package for Jupyter with essential packages
    package = pkgs.python311.withPackages (ps:
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
      c.ServerApp.allow_remote_access = True
      c.ServerApp.disable_check_xsrf = True
      c.ServerApp.open_browser = False

      # Resource limits
      c.ServerApp.max_buffer_size = 268435456  # 256MB
      c.ServerApp.max_body_size = 2147483648   # 2GB for large file uploads

      # Kernel management
      c.MappingKernelManager.cull_idle_timeout = 7200    # 2 hours
      c.MappingKernelManager.cull_interval = 300         # Check every 5 minutes
      c.MappingKernelManager.cull_connected = False      # Don't cull connected kernels

      # Working directory
      c.ServerApp.root_dir = '/home/compute/Projects'
    '';
  };

  # NVIDIA drivers and CUDA support
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Enable unfree packages for NVIDIA drivers
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.cudaSupport = true;

  # System packages for GPU development
  environment.systemPackages = with pkgs; [
    # System dependencies for Python packages
    pkg-config
    gcc
    glib
    cairo
    pango
    gdk-pixbuf
    atk

    # Development tools
    git
    nodejs # For JupyterLab extensions
    jq # For JSON processing in scripts

    # GPU monitoring tools
    nvtop
    nvidia-smi

    # Our custom scripts
    kernelDiscoveryScript
    refreshKernelsScript
  ];

  # Kernel discovery service for uv2nix projects
  systemd.services.jupyter-kernel-discovery = {
    description = "Jupyter kernel discovery for uv2nix projects";
    after = ["jupyter.service"];
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "compute";
      Group = "users";
    };

    script = "${kernelDiscoveryScript}/bin/jupyter-kernel-discovery";
  };

  # Timer for periodic kernel discovery
  systemd.timers.jupyter-kernel-discovery = {
    description = "Periodic Jupyter kernel discovery";
    wantedBy = ["timers.target"];

    timerConfig = {
      OnCalendar = "hourly"; # Check for new projects every hour
      Persistent = true;
    };
  };

  # System directories with proper permissions
  systemd.tmpfiles.rules = [
    "d /home/compute/Projects 755 compute users -"
    "d /home/compute/.local/share/jupyter 755 compute users -"
    "d /home/compute/datasets 755 compute users -"
    "d /home/compute/results 755 compute users -"
    "d /home/compute/models 755 compute users -"
  ];
}
