# Templates provided by this flake
{
  # Each template should be an attrset with path and description
  # <name> = {
  #   path = ./name;
  #   description = "<name> template flake";
  # };

  uvPythonTemplate = {
    path = ./uvPythonTemplate;
    description = "Flake for starting a python (or integrated python) project.";
  };

  aiAgents = {
    path = ./claudeAgents;
    description = "List of claude AI agents";
  };
}
