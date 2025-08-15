# Base shell configuration that provides common functionality
# This is meant to be composed with other shell configurations
{
  pkgs,
  uvBoilerplate ? null,
  ...
}: {
  # Base development packages available in all shells
  packages = with pkgs; [
    git
    nodejs-slim
    pnpm
    uv
    awscli2
    # Basic tools for dev environment
    coreutils # Basic file, shell and text manipulation utilities
    findutils # Find, locate, and xargs commands
    gnugrep # GNU grep, egrep and fgrep
    gnused # GNU stream editor
    ripgrep # Fast line-oriented search tool
    fd # Simple, fast and user-friendly alternative to find
    bat # Cat clone with syntax highlighting
    eza # Modern replacement for ls
    htop # Interactive process viewer
    jq # Lightweight JSON processor
    watch # Execute a program periodically
    curl # Command line tool for transferring data
    wget # Internet file retriever
    tree # Display directories as trees
    unzip # Unzip utility
    zip # Zip utility
    # Extra utilities
    mermaid-cli # Mermaid diagrams
  ];

  # Base environment variables
  env = {};

  # Base shell hooks
  shellHook = ''
    # Setup node
    export PATH="./node_modules/.bin:$PATH"
  '';

  # Python environment integration (if uvBoilerplate is provided)
  python =
    if uvBoilerplate != null
    then {
      packages = uvBoilerplate.uvShellSet.packages;
      env = uvBoilerplate.uvShellSet.env;
      shellHook = uvBoilerplate.uvShellSet.shellHook;
    }
    else {
      packages = [];
      env = {};
      shellHook = "";
    };
}
