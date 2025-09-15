# Common environment requirements for all shells
{pkgs, ...}: {
  # Essential tools for all environments
  packages = with pkgs; [
    # Version control
    git

    # Package manager
    nodejs-slim
    pnpm

    # Basic utilities
    coreutils
    findutils
    gnugrep
    gnused

    # Enhanced CLI tools
    ripgrep # Fast search
    fd # Fast find
    bat # Better cat
    eza # Better ls
    htop # Process viewer
    tree # Directory tree

    # Data processing
    jq # JSON processor

    # Geospatial tools
    gdal # Geospatial Data Abstraction Library

    # Network tools
    curl
    wget

    # Archive tools
    unzip
    zip
  ];

  # Common environment variables
  env = {
    # GDAL environment variables
    GDAL_DATA = "${pkgs.gdal}/share/gdal";
    PROJ_LIB = "${pkgs.proj}/share/proj";
  };

  # Common shell initialization
  shellHook = ''
    # Node modules (already in path from base)
    export PATH="$PWD/node_modules/.bin:$PATH"
  '';
}
