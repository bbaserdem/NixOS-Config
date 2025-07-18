# Info from https://docs.anthropic.com/en/docs/claude-code/settings
# Possible models; https://docs.anthropic.com/en/docs/about-claude/models/overview
{lib, ...}: let
  # Load needed lib modules
  types = lib.types;
  submodule = types.submodule;
  # Pre-set module names
  modelNames = [
    "claude-opus-4-20250514"
    "claude-sonnet-4-20250514"
    "claude-3-7-sonnet-20250219"
    "claude-3-7-sonnet-latest"
    "claude-3-5-sonnet-20241022"
    "claude-3-5-sonnet-latest"
    "claude-3-5-haiku-20241022"
    "claude-3-5-haiku-latest"
    "claude-3-haiku-20240307"
  ];
  hooksEventNames = [
    "PreToolUse"
    "PostToolUse"
    "Notification"
    "Stop"
    "SubagentStop"
  ];

  hooksSubmodule = submodule {
    options = builtins.listToAttrs (map
      (event: {
        name = event;
        value = mkOption {
          type = types.nullOr (types.attrsOf types.str);
          default = null;
          description = "Commands for ${event} hook (e.g. { Bash = \"...\" }).";
        };
      })
      hooksEventNames);
  };

  permissionsSubmodule = submodule {
    options = {
      allow = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
        description = "Permission rules to allow tool use.";
      };

      deny = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
        description = "Permission rules to deny tool use.";
      };

      additionalDirectories = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
        description = "Additional working directories accessible to Claude.";
      };

      defaultMode = mkOption {
        type = types.nullOr (types.enum ["acceptEdits" "askUser" "denyEdits"]);
        default = null;
        description = "Default permission mode when opening Claude Code.";
      };

      disableBypassPermissionsMode = mkOption {
        type = types.nullOr (types.enum ["disable" "allow"]);
        default = null;
        description = "Controls ability to bypass permission modes.";
      };
    };
  };
in {
  settingsType = types.submodule {
    options = {
      apiKeyHelper = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Shell script path to generate an API key.";
      };

      cleanupPeriodDays = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = "Number of days to retain local chat transcripts.";
      };

      env = mkOption {
        type = types.nullOr (types.attrsOf types.str);
        default = null;
        description = "Environment variables for all Claude sessions.";
      };

      includeCoAuthoredBy = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Whether to include 'Co-authored-by: Claude' in commits.";
      };

      permissions = mkOption {
        type = types.nullOr permissionsSubmodule;
        default = null;
        description = "Tool access and repository permissions.";
      };

      hooks = mkOption {
        type = types.nullOr hooksSubmodule;
        default = null;
        description = "Lifecycle hooks for Claude Code events.";
      };

      model = mkOption {
        type = types.nullOr (types.enum modelNames);
        default = null;
        description = "Claude model version to use.";
      };

      forceLoginMethod = mkOption {
        type = types.nullOr (types.enum ["claudeai" "console"]);
        default = null;
        description = "Restrict login method to Claude.ai or Console.";
      };

      enableAllProjectMcpServers = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Automatically approve all .mcp.json servers.";
      };

      enabledMcpjsonServers = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
        description = "List of approved MCP servers.";
      };

      disabledMcpjsonServers = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
        description = "List of rejected MCP servers.";
      };
    };
  };
}
