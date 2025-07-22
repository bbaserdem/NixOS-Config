# git-arbor: Creates a worktree for each remote branch using sanitized names
{pkgs}: let
  git = "${pkgs.git}/bin/git";
  mkdir = "${pkgs.coreutils}/bin/mkdir";
  sed = "${pkgs.gnused}/bin/sed";
  tr = "${pkgs.coreutils}/bin/tr";
in
  pkgs.writeShellScriptBin "git-arbor" ''
    set -e

    # --- SETUP ---
    DIR="$${1:-.}"
    cd "$DIR" || exit 1

    if [ ! -d ".git" ]; then
      echo "$DIR is not a git repository (missing .git directory)"
      exit 1
    fi

    # --- INITIALIZE IF NEEDED ---
    # git init if needed, only if no HEAD/object files
    if [ ! -f ".git/HEAD" ] || ! ${git} rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      git init
    fi

    # Find first remote (or abort if none)
    REMOTE=$(${git} remote 2>/dev/null | head -n1)
    if [ -z "$REMOTE" ]; then
      echo "No remote configured in git repository."
      exit 1
    fi

    # --- FETCH REMOTE BRANCHES ---
    ${git} fetch "$REMOTE" --prune

    # --- SANITIZE FUNCTION ---
    sanitize() {
      printf '%s' "$1" | ${tr} '[:upper:]' '[:lower:]' | ${sed} 's#[/:]\+#:#g; s#[^a-z0-9:_-]#-#g'
    }

    # --- CREATE WORKTREES FOR REMOTE BRANCHES ---
    ${mkdir} -p worktrees

    ${git} for-each-ref --format='%(refname:strip=3)' refs/remotes/"$REMOTE"/ | \
    while read branch; do
      [ "$branch" = "HEAD" ] && continue

      WTNAME=$(sanitize "$branch")
      WTROOT="./worktrees/$WTNAME"

      # Skip if worktree already exists
      if [ -d "$WTROOT" ]; then
        echo "Worktree $WTROOT already exists, skipping."
        continue
      fi

      # If local branch doesn't exist, create it from remote
      if ! ${git} show-ref --verify --quiet "refs/heads/$branch"; then
        ${git} branch "$branch" "$REMOTE/$branch"
      fi

      ${git} worktree add "$WTROOT" "$branch"
    done

    echo "All remote branches now have a sanitized worktree in ./worktrees"
  ''
