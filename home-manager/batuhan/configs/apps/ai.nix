# Configuring AI assisted tools
{
  outputs,
  pkgs,
  config,
  ...
}: {
  # Get our modules
  imports = [
    #outputs.homeManagerModules.code-cursor
    outputs.homeManagerModules.claude-code
  ];

  # Claude config
  programs.claude-code = {
    enable = true;
    package = false;
    settings = {
      includeCoAuthoredBy = true;
      enableAllProjectMcpServers = true;
      enabledMcpjsonServers = [
        "taskmaster-ai"
        "github"
        "nixos"
      ];
      permissions = {
        defaultMode = "acceptEdits";
        additionalDirectories = [
          "${config.xdg.dataHome}/docs"
        ];
        allow = [
          "mcp__taskmaster-ai__*"
          "mcp__github__*"
          "mcp__nixos__*"
          "Bash(pnpm *)"
          "Bash(pnpx *)"
          "Bash(node *)"
          "Bash(uv run *)"
          "Bash(uv install *)"
          "Bash(uv lock)"
          "Bash(uvx *)"
          "Bash(nix *)"
          "Bash(git *)"
          "Bash(gh *)"
          "Bash(node *)"
          "Bash(find *)"
          "Bash(cd *)"
          "Bash(pwd)"
          "Bash(git *)"
          "Bash(diff *)"
          "Bash(cat *)"
          "Bash(echo *)"
          "Bash(diff *)"
          "Bash(rm *)"
          "Bash(pwd *)"
          "Bash(mv *)"
          "Bash(ls *)"
          "Bash(tree *)"
          "Bash(tree)"
          "Bash(which *)"
          "Bash(grep *)"
          "Bash(chmod *)"
          "Bash(mkdir *)"
          "Bash(touch *)"
        ];
        deny = [
          "Bash(npx *)"
          "Bash(npm *)"
          "Bash(pip *)"
          "Bash(uv sync)"
          "Bash(rm -rf /)"
          "Bash(curl * | bash)"
          "Bash(curl * | sh)"
          "Bash(eval *)"
        ];
      };
    };
  };

  # Cursor config (I don't use it anymore)
  # programs.code-cursor = {
  #   enable = false;
  #   package = pkgs.unstable.code-cursor;
  #   freezingFix = true;
  # };
}
