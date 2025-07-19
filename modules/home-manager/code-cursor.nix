# Fixes for code-cursor for systemd related stuff
{
  pkgs,
  config,
  lib,
  ...
}: let
  # Bash scripts for backup
  inherit (pkgs) writeShellScript;

  # Move to ramdisk with backups
  cursorRamdiskStart = writeShellScript "cursor-ramdisk-start" ''
    RAMDISK_DIR="/tmp/cursor-vscdb"
    CURSOR_STATE="${config.xdg.configHome}/Cursor/User/globalStorage/state.vscdb"
    BACKUP_STATE="${config.xdg.cacheHome}/state.vscdb.backup"
    TIMESTAMP=$(date +%Y%m%d-%H%M%S)

    mkdir -p "$RAMDISK_DIR"
    mkdir -p "$(dirname "$BACKUP_STATE")"

    if [ -f "$CURSOR_STATE" ] && [ ! -L "$CURSOR_STATE" ]; then
      # Copy state file to backup location
      cp "$CURSOR_STATE" "$BACKUP_STATE"
      # Copy to ramdisk, and keep a time stamped version for history
      cp "$CURSOR_STATE" "$RAMDISK_DIR/state-$TIMESTAMP.vscdb"
      cp "$CURSOR_STATE" "$RAMDISK_DIR/state.vscdb"
      ln -sfn "$RAMDISK_DIR/state.vscdb" "$CURSOR_STATE"
    fi

    if [ -L "$CURSOR_STATE" ]; then
      SYMLINK_TARGET="$(readlink "$CURSOR_STATE")"
      if [ ! -e "$SYMLINK_TARGET" ]; then
        cp "$BACKUP_STATE" "$SYMLINK_TARGET" 2>/dev/null || true
      fi
    fi
  '';

  # Restore to disk
  cursorRamdiskStop = writeShellScript "cursor-ramdisk-stop" ''
    CURSOR_STATE="${config.xdg.configHome}/Cursor/User/globalStorage/state.vscdb"

    if [ -L "$CURSOR_STATE" ]; then
      RAMDISK_STATE="$(readlink "$CURSOR_STATE")"
      cp --remove-destination "$RAMDISK_STATE" "$CURSOR_STATE"
    fi
  '';

  # Backup config periodically just in case
  cursorBackupConfig = writeShellScript "cursor-backup-config" ''
    SRC="${config.xdg.configHome}/Cursor"
    DEST_DIR="${config.xdg.cacheHome}/cursor-backups"
    TS=$(date +%Y%m%d-%H%M)
    DEST="$DEST_DIR/Cursor-$TS"

    # Guard: skip if config does not exist
    [ ! -d "$SRC" ] && exit 0

    mkdir -p "$DEST"
    cp -a "$SRC" "$DEST"

    # Keep only the 2 most recent backups, delete the rest
    cd "$DEST_DIR"
    ls -1d Cursor-* | sort -V | tail -n +3 | xargs -r rm -rf --
  '';
in {
  # Set the option toggle
  options.programs.code-cursor = {
    enable = mkEnableOption "Enable installing Cursor";

    package = mkOption {
      type = types.package;
      default = pkgs.code-cursor;
      description = "Package to install for Cursor";
    };

    freezingFix = lib.mkEnableOption "Apply tmpfs fix to Cursor's state.vscdb";
  };

  # The only thing that should be changed is the dropping of systemd units

  config = lib.mkIf config.programs.code-cursor.enable {
    # Install code cursor
    home.packages = [config.programs.code-cursor.package];
    # Apply freezing fix
    systemd.user = lib.mkIf config.programs.code-cursor.freezingFix {
      services = {
        # Ramdisk stuff
        cursor-ramdisk = {
          Unit = {
            Description = "Manage Cursor state.vscdb RAM disk lifecycle (setup & restore)";
            After = ["graphical-session.target"];
            Before = ["exit.target"];
          };
          Service = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = cursorRamdiskStart;
            ExecStop = cursorRamdiskStop;
          };
          Install.WantedBy = ["graphical-session.target"];
        };
        # Backup service
        cursor-backup = {
          Unit = {
            Description = "Backup full Cursor config hourly to .cache";
          };
          Service = {
            Type = "oneshot";
            ExecStart = cursorBackupConfig;
          };
        };
      };
      timers = {
        cursor-backup = {
          Unit = {
            Description = "Run cursor config backup every hour";
          };
          Timer = {
            OnCalendar = "hourly";
            Persistent = true;
          };
          Install.WantedBy = ["timers.target"];
        };
      };
    };
  };
}
