# Claude hooks specification
{...}: {
  # Claude code config
  programs.claude-code.settings.hooks = {
    PreToolUse = [
      {
        matcher = "Bash|Run";
        description = "Blocks python package managers besides uv";
        hooks = [
          {
            type = "command";
            command = "uv run ~/.claude/hooks/pre_tool_use_uv.py";
            timeout = 10;
          }
        ];
      }
    ];
    PostToolUse = [
    ];
    Notification = [
      {
        matcher = "";
        description = "Reminds to use uv for python";
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
}
