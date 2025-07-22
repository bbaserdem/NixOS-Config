# git-bonzai; standalone script to launch tmux sessions
{pkgs}: let
  awk = "${pkgs.gawk}/bin/awk";
  git = "${pkgs.git}/bin/git";
  grep = "${pkgs.gnugrep}/bin/grep";
  lazygit = "${pkgs.lazygit}/bin/lazygit";
  sed = "${pkgs.gnused}/bin/sed";
  tmux = "${pkgs.tmux}/bin/tmux";
  tr = "${pkgs.coreutils}/bin/tr";
  wc = "${pkgs.coreutils}/bin/wc";
in
  pkgs.writeShellScriptBin "git-bonzai" ''
    # Save which directory we are in
    CURRENT_DIR="$(pwd)"

    # Find this worktree's repo root and where its .git points
    CURRENT_WT_DIR=$(${git} rev-parse --show-toplevel)
    cd "$CURRENT_WT_DIR" || exit 1

    if [ -d "$CURRENT_WT_DIR/.git" ]; then
      # Main worktree
      GIT_WT_MAIN_DIR="$CURRENT_WT_DIR"
    else
      GITDIR=$(${sed} -n 's/^gitdir: //p' "$CURRENT_WT_DIR/.git")
      GIT_WT_MAIN_DIR=$(dirname "$(dirname "$GITDIR")")
    fi

    GIT_REPO_NAME=$(basename "$GIT_WT_MAIN_DIR")
    GIT_WT_MAIN_NAME=$(${git} -C "$GIT_WT_MAIN_DIR" symbolic-ref --short HEAD 2>/dev/null)

    GIT_WT_LINKED_DIR="$CURRENT_WT_DIR"
    GIT_WT_LINKED_NAME=$(${git} symbolic-ref --short HEAD 2>/dev/null)

    # Create sanitized session name (lowercase, non-alphanum to -)
    SESSION_NAME=$(printf '%s\n' "$GIT_REPO_NAME" | ${tr} '[:upper:]' '[:lower:]' | ${sed} 's/[^a-z0-9]/-/g')

    # Exit if tmux session exists
    if ${tmux} has-session -t "$SESSION_NAME" 2>/dev/null; then
      cd "$CURRENT_DIR"
      exit 0
    fi

    # Window 0: lazygit (pane title GIT_REPO_NAME)
    ${tmux} new-session -d -s "$SESSION_NAME" -c "$GIT_WT_MAIN_DIR" -n "$GIT_REPO_NAME" "${lazygit}"
    ${tmux} select-pane -T "$GIT_REPO_NAME" -t "''${SESSION_NAME}:0.0"

    # Window 1: main branch, 2-pane vertical split, title is branch name
    ${tmux} new-window -t "$SESSION_NAME" -c "$GIT_WT_MAIN_DIR" -n "$GIT_WT_MAIN_NAME"
    ${tmux} split-window -v -t "''${SESSION_NAME}:1" -c "$GIT_WT_MAIN_DIR"
    ${tmux} select-pane -t "''${SESSION_NAME}:1.0" -T "shell 1"
    ${tmux} select-pane -t "''${SESSION_NAME}:1.1" -T "shell 2"

    # Parse all worktrees except main
    ${git} worktree list --porcelain | \
    ${awk} -v main="$GIT_WT_MAIN_DIR" '
      BEGIN{RS="";FS="\n"}
      {
        wtdir=""; branch="";
        for(i=1;i<=NF;i++){
          if($i ~ /^worktree /) wtdir=substr($i,10)
          if($i ~ /^branch /) branch=substr($i,8)
        }
        if(wtdir != main) print wtdir "|" branch
      }
    ' | while IFS='|' read wt_dir wt_branch; do
      # Window title is branch name
      ${tmux} new-window -t "$SESSION_NAME" -c "$wt_dir" -n "$wt_branch"
      ${tmux} split-window -v -t "''${SESSION_NAME}:$(tmux list-windows -t "$SESSION_NAME" | ${wc} -l | ${awk} '{print $1-1}')" -c "$wt_dir"
      ${tmux} select-pane -t "''${SESSION_NAME}:$(tmux list-windows -t "$SESSION_NAME" | ${wc} -l | ${awk} '{print $1-1}').0" -T "shell 1"
      ${tmux} select-pane -t "''${SESSION_NAME}:$(tmux list-windows -t "$SESSION_NAME" | ${wc} -l | ${awk} '{print $1-1}').1" -T "shell 2"
    done

    # Focus second window (main worktree shell)
    ${tmux} select-window -t "''${SESSION_NAME}:1"
    ${tmux} select-pane -t "''${SESSION_NAME}:1.0"

    cd "$CURRENT_DIR"
    exit 0

  ''
