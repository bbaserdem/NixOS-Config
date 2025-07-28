# Scripts for different types of swarms
{
  pkgs,
  uvBoilerplate,
  projectName,
  outputs,
  ...
}: {
  ${projectName} = {
    type = "app";
    # THIS NEEDS TO CHANGE
    program = "${outputs.packages.${system}.default}/bin/${projectName}";
  };
}
