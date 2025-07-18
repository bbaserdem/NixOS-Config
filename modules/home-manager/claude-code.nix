{
  config,
  lib,
  pkgs,
  outputs,
  ...
}:
with lib; let
  cfg = config.programs.claude-code;
  claudeSettings = import ./claude-settings-schema.nix {inherit lib;};
  # Pull the stripping function from our library
  stripUtils = outputs.lib.stripUtils;
  strip = stripUtils.stripNullsDeep;

  settingsJSON = settings:
    pkgs.writeText "claude-settings.json" (builtins.toJSON strip settings);
  globalConfigSubmodule = types.submodule {
    options = {
      autoUpdates = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Enable automatic updates (default: true).";
      };

      preferredNotifChannel = mkOption {
        type = types.nullOr (types.enum [
          "iterm2"
          "iterm2_with_bell"
          "terminal_bell"
          "notifications_disabled"
        ]);
        default = null;
        description = "Where to show notifications.";
      };

      theme = mkOption {
        type = types.nullOr (types.enum [
          "dark"
          "light"
          "light-daltonized"
          "dark-daltonized"
        ]);
        default = null;
        description = "Claude Code color theme.";
      };

      verbose = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Show full command outputs.";
      };
    };
  };
in {
  options.programs.claude-code = {
    enable = mkEnableOption "Claude Code";

    package = mkOption {
      type = types.package;
      default = pkgs.claude-code;
      description = "Package to install for Claude Code.";
    };

    globalInstructions = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Markdown string saved as ~/.claude/CLAUDE.md";
    };

    settings = mkOption {
      type = types.nullOr claudeSettings.settingsType;
      default = null;
      description = ''
        Settings written to ~/.claude/settings.json.
        Schema: https://docs.anthropic.com/en/docs/claude-code/settings
      '';
    };

    globalConfig = mkOption {
      type = types.nullOr globalConfigSubmodule;
      default = null;
      description = ''
        Settings applied via `claude config set -g`. These are not written to JSON
        but applied via an activation hook after home-manager switch.
      '';
    };
  };

  config = mkIf config.programs.claude-code.enable {
    home.packages = [config.programs.claude-code.package];

    home.file.".claude/CLAUDE.md" = mkIf (config.programs.claude-code.globalInstructions != null) {
      text = config.programs.claude-code.globalInstructions;
    };

    home.file.".claude/settings.json" = mkIf (config.programs.claude-code.settings != null) {
      source = settingsJSON config.programs.claude-code.settings;
    };

    home.activation.claudeGlobalConfig = lib.hm.dag.entryAfter ["writeBoundary"] (
      let
        settings = cfg.globalConfig;
        rendered = lib.concatStringsSep "\n" (
          lib.mapAttrsToList (
            key: val: let
              valStr =
                if builtins.isBool val
                then
                  (
                    if val
                    then "true"
                    else "false"
                  )
                else toString val;
            in ''
              echo " - Setting ${key}..."
              claude config set -g ${key} '${valStr}'
            ''
          ) (lib.filterAttrs (_: v: v != null) settings)
        );
      in ''
        if command -v claude &>/dev/null; then
          echo "Applying Claude global config..."
          ${rendered}
        else
          echo "⚠️ Claude not found in PATH; skipping globalConfig."
        fi
      ''
    );
  };
}
