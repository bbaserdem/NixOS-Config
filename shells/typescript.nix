# shell.nix
{pkgs, ...}:
pkgs.mkShell {
  packages = with pkgs; [
    # Default stuff
    nodejs-slim
    pnpm
    git
    # Python tooling for mcp's
    uv
    # Primary package manager
    bun
  ];
  shellHook = ''
    # Setup node
    export PATH="./node_modules/.bin:$PATH"

    # Set environment variables for better Bun experience
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"

    # Disable telemetry for privacy (optional)
    export DO_NOT_TRACK=1
    export DISABLE_TELEMETRY=1
  '';
  # Environment variables
  env = {
    NODE_ENV = "development";
    NO_UPDATE_NOTIFIER = "1";
  };
}
