# List of userspace applications
{...}: {
  # Import claude settings for hooks
  imports = [
    ./claude
  ];

  # Claude code config
  programs.claude-code = {
    # Enable configuration without installing, we will install manually
    enable = true;
    package = null;

    # Configuration
    agentsDir = ./claude/agents;
    hooksDir = ./claude/hooks;
    skillsDir = ./claude/skills;
    commandsDir = ./claude/commands;
    mcpServers = {};

    # Settings to go to settings.json
    settings = {
      includeCoAuthoredBy = false;
    };
  };
}
