# git-sprout; create a new worktree branch from heuristics
{pkgs}: let
  git = "${pkgs.git}/bin/git";
  sed = "${pkgs.gnused}/bin/sed";
  tmux = "${pkgs.tmux}/bin/tmux";
  tr = "${pkgs.coreutils}/bin/tr";
in
  pkgs.writeShellScriptBin "git-sprout" ''
    set -e
    export LC_ALL=C

    # Save which directory we are in
    CURRENT_DIR="$(pwd)"

    # Find current worktree root (the one user is in)
    CURRENT_WT_DIR=$(${git} rev-parse --show-toplevel)
    cd "$CURRENT_WT_DIR" || exit 1

    # Find main worktree root (repository's main checkout)
    git_common_dir=$(${git} rev-parse --git-common-dir 2>/dev/null)
    case "$git_common_dir" in
      /*) abs_git_common_dir="$git_common_dir" ;;
      *) abs_git_common_dir="$CURRENT_WT_DIR/$git_common_dir" ;;
    esac
    GIT_WT_MAIN_DIR=$(cd "$abs_git_common_dir/.." 2>/dev/null && pwd)
    GIT_REPO_NAME=$(basename "$GIT_WT_MAIN_DIR")
    GIT_WT_MAIN_NAME=$(${git} -C "$GIT_WT_MAIN_DIR" symbolic-ref --short HEAD 2>/dev/null)

    # --- ARGUMENT PARSING ---
    BASE_BRANCH=""
    while [ $# -gt 0 ]; do
      case "$1" in
        --base)
          if [ -z "$2" ]; then
            echo "Error: --base requires an argument"
            exit 1
          fi
          BASE_BRANCH="$2"
          shift 2
          ;;
        -*)
          echo "Error: Unknown option: $1"
          echo "Usage: git-sprout [--base <branch>] <branch-name>"
          exit 1
          ;;
        *)
          if [ -n "$GIT_WT_LINKED_NAME" ]; then
            echo "Error: Multiple branch names provided"
            echo "Usage: git-sprout [--base <branch>] <branch-name>"
            exit 1
          fi
          GIT_WT_LINKED_NAME="$1"
          shift
          ;;
      esac
    done

    if [ -z "$GIT_WT_LINKED_NAME" ]; then
      echo "Error: Branch name is required"
      echo "Usage: git-sprout [--base <branch>] <branch-name>"
      exit 1
    fi

    # --- NAME SANITIZATION ---
    sanitize() {
      printf '%s' "$1" | ${tr} '[:upper:]' '[:lower:]' | ${sed} 's|[/:]\+|-|g; s|[^a-z0-9:_-]|-|g'
    }
    SANITIZED=$(sanitize "$GIT_WT_LINKED_NAME")
    GIT_WT_LINKED_DIR="$GIT_WT_MAIN_DIR/worktrees/$SANITIZED"

    # --- CHECK IF WORKTREE ALREADY EXISTS ---
    if [ -d "$GIT_WT_LINKED_DIR" ]; then
      echo "Worktree directory already exists at $GIT_WT_LINKED_DIR"
      exit 0
    fi

    # --- DETERMINE EXISTING BRANCHES ---
    local_branch=""
    remote_branch=""

    if ${git} show-ref --verify --quiet "refs/heads/$GIT_WT_LINKED_NAME"; then
      local_branch="yes"
    fi

    if ${git} ls-remote --exit-code --heads origin "$GIT_WT_LINKED_NAME" >/dev/null 2>&1; then
      remote_branch="yes"
    fi

    base_branch=""

    # --- PRIMARY LOGIC ---

    if [ -n "$local_branch" ]; then
      base_branch="$GIT_WT_LINKED_NAME"
    elif [ -n "$remote_branch" ]; then
      base_branch="origin/$GIT_WT_LINKED_NAME"
    elif [ -n "$BASE_BRANCH" ]; then
      # Use user-specified base branch
      if ${git} show-ref --verify --quiet "refs/heads/$BASE_BRANCH"; then
        base_branch="$BASE_BRANCH"
      elif ${git} ls-remote --exit-code --heads origin "$BASE_BRANCH" >/dev/null 2>&1; then
        base_branch="origin/$BASE_BRANCH"
      else
        echo "Error: Specified base branch '$BASE_BRANCH' not found locally or on origin."
        exit 1
      fi
    else
      # Fallback: common base (main/master)
      if ${git} show-ref --verify --quiet "refs/heads/main"; then
        base_branch="main"
      elif ${git} show-ref --verify --quiet "refs/heads/master"; then
        base_branch="master"
      elif ${git} ls-remote --exit-code --heads origin main >/dev/null 2>&1; then
        base_branch="origin/main"
      elif ${git} ls-remote --exit-code --heads origin master >/dev/null 2>&1; then
        base_branch="origin/master"
      else
        echo "Could not determine a suitable base branch."
        exit 1
      fi
    fi

    # --- CREATE WORKTREE ---
    ${git} -C "$GIT_WT_MAIN_DIR" worktree add -b "$GIT_WT_LINKED_NAME" "$GIT_WT_LINKED_DIR" "$base_branch"
    created=1

    # --- TMUX INTEGRATION ---
    # Session name sanitization (same as bonzai script)
    SESSION_NAME=$(printf '%s\n' "$GIT_REPO_NAME" | ${tr} '[:upper:]' '[:lower:]' | ${sed} 's/[^a-z0-9]/-/g')

    if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
      # Add a new window for the new worktree
      win_idx=$(${tmux} new-window -d -P -F '#I' -t "$SESSION_NAME" -c "$GIT_WT_LINKED_DIR" -n "$GIT_WT_LINKED_NAME")
      ${tmux} split-window -v -t "$SESSION_NAME:$win_idx" -c "$GIT_WT_LINKED_DIR"
      ${tmux} select-pane -t "$SESSION_NAME:$win_idx.0" -T "shell 1"
      ${tmux} select-pane -t "$SESSION_NAME:$win_idx.1" -T "shell 2"
    fi

    exit 0

  ''
