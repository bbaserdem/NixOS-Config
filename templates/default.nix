# Templates provided by this flake
{
  # Each template should be an attrset with path and description
  # <name> = {
  #   path = ./name;
  #   description = "<name> template flake";
  # };

  uvPython = {
    path = ./adaptablePythonTemplate;
    description = "Flake for starting a python (or integrated python) project.";
  };

  cudaPython = {
    path = ./cudaPythonTemplate;
    description = "Flake for starting a CUDA using Python project.";
  };

  rust = {
    path = ./rustTemplate;
    description = "Flake for starting a Rust project with direnv integration.";
  };
}
