{
  config,
  lib,
  pkgs,
  ...
}: {
  # Accept nvidia license
  nixpkgs.config.nvidia.acceptLicense = true;
  # Add to cachix
  nix.settings = {
    substituters = [
      "https://cuda-maintainers.cachix.org"
    ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  # Enable NVIDIA drivers
  services.xserver.videoDrivers = ["nvidia"];

  # NVIDIA hardware configuration
  hardware = {
    nvidia = {
      # Use the production driver
      open = false;

      # Select the appropriate driver version for RTX 4070 Super
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      # Power management (important for servers)
      powerManagement = {
        enable = true;
        finegrained = false;
      };
    };

    # Enable OpenGL for CUDA compute
    opengl.enable = true;

    # Enable nvidia inside containers
    nvidia-container-toolkit.enable = true;
  };

  # CUDA toolkit system-wide
  environment.systemPackages = with pkgs; [
    cudatoolkit
    cudaPackages.cudnn
    nvidia-docker
  ];

  # Enable container runtime for NVIDIA
  virtualisation.docker.enableNvidia = true;

  # Add CUDA to system environment
  environment.variables = {
    CUDA_PATH = "${pkgs.cudatoolkit}";
    CUDA_ROOT = "${pkgs.cudatoolkit}";
    LD_LIBRARY_PATH = "${pkgs.cudatoolkit}/lib:${pkgs.cudatoolkit.lib}/lib";
  };

  # Ensure proper permissions for GPU access
  users.users.batuhan.extraGroups = ["video"];
}

