# Git-bonzai; standalone script to launch zellij instances
{pkgs}: let
  zellij = "${pkgs.zellij}/bin/zellij";
  git = "${pkgs.git}/bin/git";
  awk = "${pkgs.gawk}/bin/awk";
  grep = "${pkgs.gnugrep}/bin/grep";
  mktemp = "${pkgs.mktemp}/bin/mktemp";
in
  pkgs.writeShellScriptBin "git-bonzai" ''
    NAME=""
    FROM=""
    DEFAULT_BRANCH="main"

    # --- Parse args ---
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --from)
          FROM="$2"
          shift 2
          ;;
        *)
          NAME="$1"
          shift
          ;;
      esac
    done

    if [[ -z "$NAME" ]]; then
      echo "Usage: git-bloom NAME [--from BRANCH]"
      exit 1
    fi

    # --- Determine root dirs ---
    GIT_ROOT=$(${git} rev-parse --show-toplevel)
    GIT_REPO_ROOT=$(realpath "$(${git} rev-parse --git-common-dir)/..")
    WORKTREES_DIR="$GIT_REPO_ROOT/worktrees"
    SANITIZED_NAME="$${NAME//\//-}"

    TARGET_DIR="$WORKTREES_DIR/$SANITIZED_NAME"
    BRANCH_EXISTS_LOCALLY=$(${git} show-ref --verify --quiet "refs/heads/$NAME" && echo yes || echo no)
    BRANCH_EXISTS_REMOTELY=$(${git} ls-remote --exit-code --heads origin "$NAME" &>/dev/null && echo yes || echo no)

    mkdir -p "$WORKTREES_DIR"

    # --- Determine branch source ---
    if [[ "$BRANCH_EXISTS_LOCALLY" == "yes" || "$BRANCH_EXISTS_REMOTELY" == "yes" ]]; then
      if [[ -n "$FROM" ]]; then
        echo "Got argument --from $FROM , but $NAME already exists!"
        exit 1
      else
        echo "Using existing branch: $NAME"
        ${git} worktree add "$TARGET_DIR" "$NAME"
      fi
    else
      BASE="$DEFAULT_BRANCH"

      if [[ -n "$FROM" ]]; then
        BASE="$FROM"
      else
        IFS='/-_' read -ra PARTS <<< "$NAME"
        for i in "$${!PARTS[@]}"; do
          PREFIX="$${PARTS[*]:0:$((i+1))}"
          CANDIDATE="$${PREFIX// /-}"
          if ${git} show-ref --verify --quiet "refs/heads/$CANDIDATE"; then
            BASE="$CANDIDATE"
            break
          fi
        done
      fi

      echo "Creating new branch: $NAME from $BASE"
      git worktree add -b "$NAME" "$TARGET_DIR" "$BASE"
    fi

    # --- Zellij Session Setup ---
    # Only if there is already a session
    SESSION_NAME=$(basename "$GIT_REPO_ROOT" | tr -c '[:alnum:]' '-')
    if ${zellij} list-sessions | grep -q "^$SESSION_NAME\$"; then

      # Check if there is a template, generate if none
      TEMPLATE="$${GIT_REPO_ROOT}/.zellijrc.kdl"
      if [[ ! -f "$TEMPLATE" ]]; then
        TEMPLATE="$(${mktemp} --suffix .zellijrc.kdl)"
        cat <<EOF >"$TEMPLATE"
    layout {
      tab name="$${NAME}" {
        pane { }
        pane { }
      }
    }
    EOF
      fi
      
      ${zellij} action load-layout "$TEMPLATE" --cwd "$TARGET_DIR" 

      echo "Opened worktree in zellij session: $SESSION_NAME (tab: $NAME)"
    fi

    cd "$TARGET_DIR"
  '';
