# Configuring AI assisted tools
{
  outputs,
  pkgs,
  config,
  ...
}: {
  # Get our modules
  imports = [
    outputs.homeManagerModules.code-cursor
    outputs.homeManagerModules.claude-code
  ];

  # Cursor config (not in use anymore)
  programs.code-cursor = {
    enable = false;
    package = pkgs.unstable.code-cursor;
    freezingFix = true;
  };

  # Claude config
  programs.claude-code = {
    enable = true;
    package = false;
    settings = {
      includeCoAuthoredBy = true;
      enableAllProjectMcpServers = true;
      permissions = {
        defaultMode = "acceptEdits";
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
    globalInstructions = builtins.readFile ./Claude.md;
  };

  # Install amp-cli
  home.packages = [pkgs.unstable.amp-cli];
}
