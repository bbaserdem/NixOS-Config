# Git-bonzai; standalone script to launch zellij instances
{pkgs}: let
  zellij = "${pkgs.zellij}/bin/zellij";
  git = "${pkgs.git}/bin/git";
  awk = "${pkgs.gawk}/bin/awk";
  grep = "${pkgs.gnugrep}/bin/grep";
  mktemp = "${pkgs.mktemp}/bin/mktemp";
in
  pkgs.writeShellScriptBin "git-bonzai" ''
    # Determine repo location and branch
    GIT_ROOT=$(${git} rev-parse --show-toplevel)
    GIT_BRANCH=$(${git} rev-parse --abbrev-ref HEAD)
    GIT_REPO_ROOT=$(realpath "$(${git} rev-parse --git-common-dir)/..")

    # Only run on main or master
    if [[ "$GIT_BRANCH" != "main" && "$GIT_BRANCH" != "master" ]]; then
      echo "Not on main/master branch, skipping zellij session setup."
      exit 0
    elseif [[ "$GIT_ROOT" != "$GIT_REPO_ROOT" ]] ; then
      echo "The worktree root is not the main/master branch, skipping setup"
      exit 0
    fi

    # Use the repo name as session name
    REPO_NAME=$(basename "$GIT_ROOT")
    SESSION_NAME="$(echo "$GIT_ROOT" | tr -c '[:alnum:]' '-')"

    # If zellij session already exists, do nothing
    if ${zellij} list-sessions | grep -q "^$SESSION_NAME\$"; then
      echo "Zellij session '$SESSION_NAME' already running."
      exit 0
    fi

    # Prepare layout: use .zellij-layout.kdl from repo or fallback to a default
    if [[ -f "$GIT_ROOT/.zellij-layout.kdl" ]]; then
      LAYOUT_FILE="$GIT_REPO_ROOT/.zellij-layout.kdl"
    else
      LAYOUT_FILE="$(mktemp --suffix .zellij-layout.kdl)"
      cat > "$LAYOUT_FILE" <<EOF
    layout {
      tab {
        pane size=1 borderless=false { }
        pane borderless=false { }
      }
    }
    EOF
    fi

    # Start new session with layout
    ${zellij} --session "$SESSION_NAME" --layout "$ZELLIJ_LAYOUT" --cwd "$GIT_ROOT" &
    sleep 0.5

    # Open tabs for all worktrees (skip the main repo)
    mapfile -t WORKTREES < <(${git} worktree list --porcelain | ${awk} '/worktree/ { print $2 }' | ${grep} -v "^$GIT_ROOT\$")

    for wt in "$${WORKTREES[@]}"; do
      ${zellij} --session "$SESSION_NAME" --layout "$ZELLIJ_LAYOUT" --cwd "$wt"
    done

    # Go back to first tab (main repo)
    ${zellij} action go-to-tab --session "$SESSION_NAME" --tab-index 0

    echo "Zellij session '$SESSION_NAME' with worktrees launched."

  ''
