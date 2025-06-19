{
  description = "WebApp development shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            # Node.js and package manager
            pkgs.nodejs_20
            pkgs.nodePackages.pnpm
            pkgs.git

            # Unix utilities
            pkgs.coreutils # Basic file, shell and text manipulation utilities
            pkgs.findutils # Find, locate, and xargs commands
            pkgs.gnugrep # GNU grep, egrep and fgrep
            pkgs.gnused # GNU stream editor
            pkgs.ripgrep # Fast line-oriented search tool
            pkgs.fd # Simple, fast and user-friendly alternative to find
            pkgs.bat # Cat clone with syntax highlighting
            pkgs.eza # Modern replacement for ls
            pkgs.htop # Interactive process viewer
            pkgs.jq # Lightweight JSON processor
            pkgs.watch # Execute a program periodically
            pkgs.curl # Command line tool for transferring data
            pkgs.wget # Internet file retriever
            pkgs.tree # Display directories as trees
            pkgs.unzip # Unzip utility
            pkgs.zip # Zip utility
          ];

          shellHook = ''
            # Make our node packages available to our shell
            export PATH="./node_modules/.bin:$PATH"
          '';
        };
      }
    );
}
