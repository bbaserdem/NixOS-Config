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
    code-cursor_1_1_6
    unstable.claude-code
  ];
}
