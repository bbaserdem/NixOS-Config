# Templates provided by this flake
{
  # Each template should be an attrset with path and description
  # <name> = {
  #   path = ./name;
  #   description = "<name> template flake";
  # };

  uvPythonTemplate = {
    path = ./adaptablePythonTemplate;
    description = "Flake for starting a python (or integrated python) project.";
  };

  skyfi = {
    path = ./SkyFi;
    description = "Flake for starting a geospatial imaging project.";
  };
}
