# Cursor wrapper to fix freezing issues by cleaning chat history
{pkgs, ...}: let
  sq3 = "${pkgs.sqlite}/bin/sqlite3";
  cursor-wrapped = pkgs.writeShellApplication {
    name = "cursor-wrapped";
    runtimeInputs = with pkgs; [
      unstable.code-cursor
      findutils
      coreutils
      sqlite
    ];
    text = ''
      # Cursor Wrapper with Background Cleanup

      # Start background cleanup process
      start_background_cleanup() {
        echo "Starting background Cursor cleanup (every 5 minutes)..."

        # Background cleanup loop
        (
          while true; do
            sleep 300  # 5 minutes

            # Check if parent Cursor process is still running
            if ! kill -0 $$ 2>/dev/null; then
              echo "Cursor wrapper exited, stopping background cleanup"
              break
            fi

            # Run the oneshot cleanup service
            systemctl --user start cursor-cleanup.service
          done
        ) &

        # Store background process PID
        CLEANUP_PID=$!
        echo "Background cleanup started with PID: $CLEANUP_PID"
      }

      # Cleanup function for when Cursor exits
      cleanup_on_exit() {
        if [[ -n "$CLEANUP_PID" ]]; then
          echo "Stopping background cleanup (PID: $CLEANUP_PID)..."
          kill "$CLEANUP_PID" 2>/dev/null
          wait "$CLEANUP_PID" 2>/dev/null
          echo "Background cleanup stopped"
        fi
      }

      # Set up exit trap
      trap cleanup_on_exit EXIT

      # Parse arguments for options
      DISABLE_BACKGROUND=false

      for arg in "$@"; do
        case $arg in
          --no-background-cleanup)
            DISABLE_BACKGROUND=true
            shift
            ;;
        esac
      done

      # Start background cleanup unless disabled
      if [[ "$DISABLE_BACKGROUND" == false ]]; then
        start_background_cleanup
      fi

      # Run initial cleanup
      echo "Running initial cleanup..."
      systemctl --user start cursor-cleanup.service

      # Start original cursor with all arguments
      exec ${pkgs.unstable.code-cursor}/bin/cursor "$@"
    '';
  };
in {
  home.packages = [
    cursor-wrapped
    pkgs.unstable.code-cursor
  ];

  systemd.user.services.cursor-cleanup = {
    Unit = {
      Description = "Cursor database cleanup to prevent freezing";
    };

    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "cursor-cleanup-script" ''
        # Cursor cleanup script
        CURSOR_CONFIG_DIR="$HOME/.config/Cursor"
        CURSOR_HISTORY_DIR="$CURSOR_CONFIG_DIR/User/History"
        CURSOR_GLOBAL_STORAGE="$CURSOR_CONFIG_DIR/User/globalStorage"
        STATE_DB="$CURSOR_GLOBAL_STORAGE/state.vscdb"
        STATE_DB_JOURNAL="$CURSOR_GLOBAL_STORAGE/state.vscdb-journal"

        # Check if state.vscdb is too large (root cause of freezing)
        check_state_db_size() {
          if [[ -f "$STATE_DB" ]]; then
            size=$(du -m "$STATE_DB" | cut -f1)
            if [[ $size -gt 10 ]]; then
              echo "Warning: state.vscdb is ''${size}MB (>10MB threshold)"
              return 1
            fi
          fi
          return 0
        }

        # Clean problematic CursorDiskKV table while preserving user settings
        clean_state_db() {
          echo "Cleaning problematic CursorDiskKV table..."
          if [[ -f "$STATE_DB" ]]; then
            size=$(du -m "$STATE_DB" | cut -f1)
            echo "Database size: ''${size}MB"

            # Create backup first
            cp "$STATE_DB" "$STATE_DB.backup"

            # Clean the problematic CursorDiskKV table that causes freezing
            ${sq3} "$STATE_DB" "DELETE FROM ItemTable WHERE key LIKE '%CursorDiskKV%';" 2>/dev/null || {
              echo "SQLite cleanup failed, trying alternative approach..."

              # Fallback: Export essential tables and recreate database
              temp_sql="/tmp/cursor_essential_data.sql"

              # Extract essential user data (not CursorDiskKV)
              ${sq3} "$STATE_DB" ".dump" > "''${temp_sql}" 2>/dev/null

              # Filter out CursorDiskKV entries and recreate database
              if [[ -f "''${temp_sql}" ]]; then
                grep -v "CursorDiskKV" "''${temp_sql}" > "''${temp_sql}.clean"
                rm -f "$STATE_DB"
                ${sq3} "$STATE_DB" < "''${temp_sql}.clean" 2>/dev/null || {
                  echo "Database recreation failed, restoring backup..."
                  mv "$STATE_DB.backup" "$STATE_DB"
                  return 1
                }
                rm -f "''${temp_sql}" "''${temp_sql}.clean"
              else
                echo "Could not extract data, restoring backup..."
                mv "$STATE_DB.backup" "$STATE_DB"
                return 1
              fi
            }

            # Clean journal file
            if [[ -f "$STATE_DB_JOURNAL" ]]; then
              rm -f "$STATE_DB_JOURNAL"
            fi

            # Verify database integrity
            if ${sq3} "$STATE_DB" "PRAGMA integrity_check;" | grep -q "ok"; then
              echo "Database cleaned successfully"
              rm -f "$STATE_DB.backup"
            else
              echo "Database integrity check failed, restoring backup..."
              mv "$STATE_DB.backup" "$STATE_DB"
              return 1
            fi
          fi
        }

        # Clean chat history (secondary prevention)
        clean_chat_history() {
          if [[ -d "$CURSOR_HISTORY_DIR" ]]; then
            echo "Cleaning Cursor chat history..."
            session_count=$(find "$CURSOR_HISTORY_DIR" -mindepth 1 -maxdepth 1 -type d | wc -l)
            echo "Found $session_count chat sessions"
            rm -rf "$CURSOR_HISTORY_DIR"/*
            echo "Chat history cleaned"
          fi
        }

        # Only clean if database is too large
        if ! check_state_db_size; then
          clean_state_db
        fi

        # Always clean chat history (lightweight)
        clean_chat_history

        echo "Cursor cleanup completed"
      '';
    };
  };
}
