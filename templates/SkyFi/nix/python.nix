# Python project spec
{
  # Single package configuration
  projectName = "skyfi";
  projectRoot = ".";
  # projectDir is optional - if not defined, defaults to "src/<sanitizedName>"

  # No workspaces for simple single package template
  # if monorepo, define it here
  # workspaces = [
  #   {
  #     projectName = "template-backend";
  #     projectRoot = "backend";
  #     projectDir = "backend/src/backend";
  #   }
  # ];
  # If monorepo, but with empty root directory, define here
  # emptyRoot = true;
}
