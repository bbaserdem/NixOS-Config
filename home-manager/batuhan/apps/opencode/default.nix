# home-manager/batuhan/apps/opencode/default.nix
# Agents and commands for opencode
{...}: {
  # Agents
  programs.opencode = {
    agents = {
      # my-agent = ./my-agent.md;
    };
  };
}
