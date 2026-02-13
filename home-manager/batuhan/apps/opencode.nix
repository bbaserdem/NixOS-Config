# home-manager/batuhan/apps/opencode.nix
# Opencode configuration from home-manager
{...}: {
  # External config
  imports = [
    ./opencode
  ];

  # Claude code config
  programs.opencode = {
    # Enable configuration without installing, we will install manually
    enable = true;
    package = null;

    # Configuration
    enableMcpIntegration = true;
    settings = {
      # Custom lsp's
      lsp = {
        ty = {
          command = ["ty" "server"];
          extensions = [".py"];
        };
      };
      # Custom formatters
      formatter = {
        nixfmt = {
          disabled = true;
        };
        alejandra = {
          command = ["alejandra"];
          extensions = [".nix"];
        };
      };
      # Permissions
      permission = {
        external_directory."*" = "deny";
      };
    };

    # Global rule file
    rules = ''
      # Global Rules

      ## External File Loading

      CRITICAL: When you encounter a file reference (e.g., @rules/general.md), use your Read tool to load it on a need-to-know basis.
      They're relevant to the SPECIFIC task at hand.

      Instructions:

      - Do NOT preemptively load all references - use lazy loading based on actual need
      - When loaded, treat content as mandatory instructions that override defaults
      - Follow references recursively when needed

      ## Development Guidelines

      We are using devshell provided by nix flakes, and direnv to manage our dev enviroment.
      If you need to manipulate the environment, you must read flake.nix and .envrc and act accordingly.
      Binary dev dependencies should be put in devShells in flake.nix
      Project dependencies should be managed through the projects' package managers. (uv for python, pnpm for npm, cargo for rust, etc.)
    '';
  };

  # Disable auto-lsp downloads
  home.sessionVariables = {
    OPENCODE_DISABLE_LSP_DOWNLOAD = "true";
    OPENCODE_EXPERIMENTAL_LSP_TOOL = "true";
    OPENCODE_ENABLE_EXA = 1;
    OPENCODE_DISABLE_CLAUDE_CODE = 1;
  };
}
