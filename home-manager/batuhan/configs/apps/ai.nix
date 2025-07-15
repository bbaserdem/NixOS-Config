# Configuring AI assisted tools
{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}: {
  # Get cursor editor with fixes
  imports = [
    ./aiCursor.nix
  ];

  home.packages =
    # Node to be able to get MCP's
    [pkgs.nodePackages_latest.nodejs]
    ++ (with pkgs.unstable; [
      # Other AI assisted coding flows
      claude-code
      amp-cli
    ])
    ++ (with pkgs.unstable; [
      # MCP's
      task-master-ai
    ]);
}
