# Configuring AI assisted tools
{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}: {
  # Get cursor editor, custom overlay already applied
  # Also get anthropic's claude
  home.packages = with pkgs.unstable; [
    code-cursor
    claude-code
    task-master-ai
  ];
}
