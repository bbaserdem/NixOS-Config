# nixos/services/jupyter.nix
# Custom Jupyter Lab server setup - independent of NixOS module
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myNixOS.services.jupyter;

  # Use whatever python version we want as base
  pythonVersion = "313";
  #pythonPackages = pkgs."python${pythonVersion}Packages";
  python = pkgs."python${pythonVersion}";

  # Build the Python environment with Jupyter and extra packages
  package = python.withPackages (
    ps:
      [
        ps.jupyterlab # The base jupyterlab package
        ps.nbformat # Notebook generator
      ]
      ++ cfg.extraPackages ps
  );

  # Jupyter configuration file
  notebookConfig = pkgs.writeText "jupyter_server_config.py" ''
    ${cfg.notebookConfig}
    ${
      if cfg.password == null
      then ''
        c.ServerApp.token = ""
        c.ServerApp.password = ""
        c.IdentityProvider.token = ""
      ''
      else ''
        c.ServerApp.password = "${cfg.password}"
      ''
    }
    c.ServerApp.root_dir = '${cfg.notebookDir}'

    # Auto-select kernel based on project directory
    import sys
    sys.path.insert(0, '${pkgs.scripts-jupyter}/lib/python')
    try:
        from jupyter_kernel_autoselect import setup_kernel_autoselect
        setup_kernel_autoselect(c)
        print("Kernel auto-selection enabled")
    except ImportError as e:
        print(f"Could not load kernel auto-selection: {e}")
    except Exception as e:
        print(f"Error setting up kernel auto-selection: {e}")
  '';
in {
  options.myNixOS.services.jupyter = {
    # Enable switch already provided by module loading

    ip = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "IP address Jupyter will be listening on";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8888;
      description = "Port number Jupyter will be listening on";
    };

    extraPackages = lib.mkOption {
      type = lib.types.functionTo (lib.types.listOf lib.types.package);
      default = ps: [];
      example = lib.literalExpression ''
        ps: with ps; [
          ipykernel
          numpy
          pandas
          matplotlib
        ]
      '';
      description = "Function that returns extra Python packages for Jupyter";
    };

    command = lib.mkOption {
      type = lib.types.str;
      default = "jupyter-lab";
      description = "Command to run (jupyter-lab or jupyter-notebook)";
    };

    notebookDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.users.users.${config.myNixOS.userName}.home}/Projects";
      description = "Root directory for notebooks";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = config.users.users.${config.myNixOS.userName}.name;
      description = "User to run the service as";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "users";
      description = "Group to run the service as";
    };

    password = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Hashed password for Jupyter (null to disable auth)";
    };

    notebookConfig = lib.mkOption {
      type = lib.types.lines;
      default = ''
        # JupyterLab configuration
        c.ServerApp.allow_remote_access = False
        c.ServerApp.disable_check_xsrf = True
        c.ServerApp.open_browser = False

        # Resource limits
        c.ServerApp.max_buffer_size = 2147483648 # 2GB
        c.ServerApp.max_body_size = 2147483648   # 2GB

        # Kernel management
        c.MappingKernelManager.cull_idle_timeout = 7200    # 2 hours
        c.MappingKernelManager.cull_interval = 300         # Check every 5 minutes
        c.MappingKernelManager.cull_connected = False      # Don't cull connected
      '';
      description = "Raw Jupyter configuration";
    };

    extraEnvironmentVariables = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Extra environment variables for Jupyter";
    };
  };

  config = lib.mkIf cfg.enable {
    # Ensure the built-in service is disabled
    services.jupyter.enable = false;

    # Kernel discovery service (can be triggered manually)
    systemd.services.jupyter-kernel-discovery = {
      description = "Discover Python virtual environments for Jupyter";

      path = [
        pkgs.nix # needed for nix develop testing
        pkgs.git # needed for git operations
      ];

      environment = {
        NIX_PATH = "nixpkgs=${pkgs.path}";
        NIX_CONFIG = "experimental-features = nix-command flakes";
      };

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.scripts-jupyter}/bin/python-kernel-finder ${cfg.notebookDir}";
        User = cfg.user;
        Group = cfg.group;
      };
    };

    # Timer to periodically rescan for kernels (every 5 minutes)
    systemd.timers.jupyter-kernel-discovery = {
      description = "Periodically discover Python kernels";
      wantedBy = ["timers.target"];

      timerConfig = {
        OnBootSec = "1min";
        OnUnitActiveSec = "5min";
      };
    };

    # Custom systemd service for jupyter lab
    systemd.services.jupyter = {
      description = "Jupyter Lab server";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];

      path = [
        pkgs.bash # needed for sh in cell magic
        pkgs.nix # needed for nix develop in devshell kernels
        pkgs.git # needed for git operations in kernel discovery
      ];

      environment =
        cfg.extraEnvironmentVariables // {
          # Ensure nix is available for devshell kernels
          NIX_PATH = "nixpkgs=${pkgs.path}";
          NIX_CONFIG = "experimental-features = nix-command flakes";
        };

      preStart = ''
        # Discover and register Python kernels from virtual environments
        ${pkgs.scripts-jupyter}/bin/python-kernel-finder "${cfg.notebookDir}"
      '';

      serviceConfig = {
        Restart = "always";
        ExecStart = ''
          ${package}/bin/${cfg.command} \
            --no-browser \
            --ip=${cfg.ip} \
            --port=${toString cfg.port} --port-retries 0 \
            --notebook-dir=${cfg.notebookDir} \
            --JupyterApp.config_file=${notebookConfig}
        '';
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.notebookDir;
      };
    };

    # Set default packages if not already specified
    myNixOS.services.jupyter.extraPackages = lib.mkDefault (ps:
      with ps; [
        ipykernel # Python kernel
        ipywidgets # Interactive widgets
        ipyparallel # Parallel computing
        # Scientific packages
        numpy
        matplotlib
        pandas
      ]);
  };
}
