# Configuring AI assisted tools
{
  outputs,
  pkgs,
  config,
  ...
}: {
  # Get cursor fix
  imports = [
    outputs.homeManagerModules.cursorFix
    outputs.homeManagerModules.claude-code
  ];

  programs.code-cursor = {
    freezingFix = false;
  };

  programs.claude-code = {
    enable = true;
    package = pkgs.unstable.code-cursor;
    settings = {
      includeCoAuthoredBy = true;
      enableAllProjectMcpServers = true;
      permissions = {
        defaultModel = "acceptEdits";
        additionalDirectories = [
          "${config.xdg.dataHome}/docs"
        ];
        allow = [
          "Bash(find:*)"
          "Bash(cd:*)"
          "Bash(git:*)"
          "Bash(diff:*)"
          "Bash(cat:*)"
          "Bash(echo:*)"
          "Bash(diff:*)"
          "Bash(rm:*)"
          "Bash(pwd:*)"
          "Bash(mv:*)"
          "Bash(ls:*)"
          "Bash(grep:*)"
          "Bash(chmod:*)"
          "Bash(mkdir:*)"
          "Bash(task-master show:*)"
          "Bash(task-master update-subtask:*)"
          "Bash(task-master set-status:*)"
          "Bash(task-master:*)"
          "Bash(touch:*)"
        ];
      };
    };
    globalConfig = {
      autoUpdates = false;
    };
    globalInstructions = ''
    '';
  };

  home.packages =
    # Node to be able to get MCP's
    [pkgs.nodePackages_latest.nodejs]
    ++ (with pkgs.unstable; [
      # AI assisted coding flows
      amp-cli
    ]);
}
