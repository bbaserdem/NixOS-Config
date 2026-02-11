# List of userspace applications
{...}: {
  imports = [
    ./claude
  ];
  # Claude code config
  programs.claude-code = {
    enable = true;
    agentsDir = ./claude/agents;
    hooksDir = ./claude/hooks;
    skillsDir = ./claude/skills;
    commandsDir = ./claude/commands;
    #memory.source = ./CLAUDE.md;
    mcpServers = {
    };
  };
}
