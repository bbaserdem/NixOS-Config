# List of userspace applications
{...}: {
  # Claude code config
  programs.claude-code = {
    enable = true;
    hooksDir = ./hooks;
    memory.source = ./CLAUDE.md;
    #agentsDir = ./agents;
    #skillsDir = ./skills;
    #commandsDir = ./commands;
    mcpServers = {
    };
    settings = {
      hooks = {
        PreToolUse = [
          {
            matcher = "Bash|Run";
            hooks = [
              {
                type = "command";
                command = "uv run ~/.claude/hooks/pre_tool_use.py";
                timeout = 10;
              }
            ];
          }
        ];
        PostToolUse = [
          {
            matcher = "Bash|Run";
            hooks = [
              {
                type = "command";
                command = "uv run ~/.claude/hooks/post_tool_use.py";
                timeout = 10;
              }
            ];
          }
        ];
        Notification = [
          {
            matcher = "";
            hooks = [
              {
                type = "command";
                command = "uv run ~/.claude/hooks/notification_uv.py";
                timeout = 10;
              }
            ];
          }
        ];
      };
    };
  };
}
