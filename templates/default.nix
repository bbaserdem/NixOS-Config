# Templates provided by this flake
{
  # Each template should be an attrset with path and description
  # <name> = {
  #   path = ./name;
  #   description = "<name> template flake";
  # };

  default = {
    path = ./default;
    description = "Empty flake template";
  };
}
