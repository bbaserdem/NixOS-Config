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
  home.packages = with pkgs; [
    code-cursor
    unstable.claude-code
  ];
}
