# Configuring AI assisted tools
{
  outputs,
  pkgs,
  ...
}: {
  # Get cursor fix
  imports = [
    outputs.homeManagerModules.cursorFix
  ];

  programs.code-cursor = {
    freezingFix = true;
  };

  home.packages =
    # Node to be able to get MCP's
    [pkgs.nodePackages_latest.nodejs]
    ++ (with pkgs.unstable; [
      # AI assisted coding flows
      code-cursor
      claude-code
      amp-cli
    ]);
}
