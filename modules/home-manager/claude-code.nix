{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.claude-code;
  claudeSettings = import ./claude-settings-schema.nix {inherit lib;};
  stripNullsDeep = value:
    if value == null
    then null
    else if builtins.isAttrs value
    then lib.attrsets.filterAttrs (_: v: v != null) (mapAttrs (_: stripNullsDeep) value)
    else if builtins.isList value
    then builtins.filter (v: v != null) (map stripNullsDeep value)
    else value;

  settingsJSON = settings:
    pkgs.writeText "claude-settings.json" (builtins.toJSON (stripNullsDeep settings));
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
      type = types.either types.package (types.enum [false]);
      default = pkgs.claude-code;
      description = "Package to install for Claude Code. Set to false to disable installation.";
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
    home.packages = mkIf (cfg.package != false) [cfg.package];

    home.file.".claude/CLAUDE.md" = mkIf (config.programs.claude-code.globalInstructions != null) {
      text = config.programs.claude-code.globalInstructions;
    };

    home.file.".claude/settings.json" = mkIf (config.programs.claude-code.settings != null) {
      source = settingsJSON config.programs.claude-code.settings;
    };

    home.activation.claudeGlobalConfig = mkIf (cfg.package != false) (lib.hm.dag.entryAfter ["writeBoundary"] (
      let
        settings = cfg.globalConfig // {autoUpdates = false;};
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
    ));
  };
}
