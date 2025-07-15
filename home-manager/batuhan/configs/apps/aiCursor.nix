# Cursor with systemd-based fixes for freezing behavior
{
  pkgs,
  config,
  ...
}: let
  backupRoot = config.xdg.cacheHome;
  configRoot = config.xdg.configHome;
  bash = "${pkgs.bash}/bin/bash";
in {
  home.packages = [
    pkgs.unstable.code-cursor
  ];

  systemd.user = {
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
          ExecStart = ''
            ${bash} -c '
              RAMDISK_DIR="/tmp/cursor-vscdb"
              CURSOR_STATE="${configRoot}/Cursor/User/globalStorage/state.vscdb"
              BACKUP_STATE="${cacheRoot}/state.vscdb.backup"
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
            '
          '';
          ExecStop = ''
            ${bash} -c '
              CURSOR_STATE="${configRoot}/Cursor/User/globalStorage/state.vscdb"

              if [ -L "$CURSOR_STATE" ]; then
                RAMDISK_STATE="$(readlink "$CURSOR_STATE")"
                cp --remove-destination "$RAMDISK_STATE" "$CURSOR_STATE"
              fi
            '
          '';
        };
        Install.WantedBy = ["default.target"];
      };

      # Backup service
      cursor-backup = {
        Unit = {
          Description = "Backup full Cursor config hourly to .cache";
        };
        Service = {
          Type = "oneshot";
          ExecStart = ''
            ${bash} -c '
              SRC="${configRoot}/Cursor"
              DEST_DIR="${cacheRoot}/cursor-backups"
              TS=$(date +%Y%m%d-%H%M)
              DEST="$DEST_DIR/Cursor-$TS"

              # Guard: skip if config does not exist
              [ ! -d "$SRC" ] && exit 0

              mkdir -p "$DEST"
              cp -a "$SRC" "$DEST"

              # Keep only the 2 most recent backups, delete the rest
              cd "$DEST_DIR"
              ls -1d Cursor-* | sort | tail -n +3 | xargs -r rm -rf --
            '
          '';
        };
        Install.WantedBy = ["default.target"];
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
        Install = {
          WantedBy = ["timers.target"];
        };
      };
    };
  };
}
