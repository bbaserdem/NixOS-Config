# Configuring AI assisted tools
{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}: {
  # Get cursor editor
  imports = [
    ./aiCursor.nix
  ];
  # Also get anthropic's claude
  home.packages = with pkgs.unstable; [
    pkgs.paraview-6
    claude-code
    task-master-ai
  ];
}
