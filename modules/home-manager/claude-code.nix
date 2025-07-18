{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  claudeSettings = import ./claude-settings-schema.nix {inherit lib;};
  strip = claudeSettings.stripNullsDeep;
  settingsJSON = settings:
    pkgs.writeText "claude-settings.json" (builtins.toJSON strip settings);
  globalSettingsSubmodule = types.submodule {
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
      type = types.nullOr settingsSchema;
      default = null;
      description = ''
        Settings written to ~/.claude/settings.json.
        Schema: https://docs.anthropic.com/en/docs/claude-code/settings
      '';
    };

    globalSettings = mkOption {
      type = types.nullOr globalSettingsSubmodule;
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

    home.activation.claudeGlobalSettings = lib.hm.dag.entryAfter ["writeBoundary"] (
      let
        settings = config.programs.claude-code.globalSettings;
        filteredSettings = lib.filterAttrs (_: v: v != null) (settings or {});
        rendered =
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
                else val;
            in ''
              echo " - Setting ${key}..."
              claude config set -g ${key} '${valStr}'
            ''
          )
          filteredSettings;
      in ''
        if command -v claude &>/dev/null; then
          echo "Applying Claude global settings..."
          ${lib.concatStringsSep "\n" rendered}
        else
          echo "⚠️ Claude not found in PATH; skipping globalSettings."
        fi
      ''
    );
  };
}
