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
    claude-code
    task-master-ai
    amp-cli
  ];
}
