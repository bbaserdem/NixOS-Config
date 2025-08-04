# git-arbor: Creates a worktree for each remote branch using sanitized names
{pkgs}: let
  awk = "${pkgs.gawk}/bin/awk";
  git = "${pkgs.git}/bin/git";
  grep = "${pkgs.gnugrep}/bin/grep";
  mkdir = "${pkgs.coreutils}/bin/mkdir";
  sed = "${pkgs.gnused}/bin/sed";
  tr = "${pkgs.coreutils}/bin/tr";
in
  pkgs.writeShellScriptBin "git-arbor" ''
    set -e
    export LC_ALL=C

    # --- SETUP ---
    DIR="''${1:-.}"
    cd "$DIR" || exit 1

    if [ ! -d ".git" ]; then
      echo "$DIR is not a git repository (missing .git directory)"
      exit 1
    fi

    # --- INITIALIZE IF NEEDED ---
    # git init if needed, only if no HEAD/object files
    if [ ! -f ".git/HEAD" ] || ! ${git} rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      ${git} init
    fi

    # Find first remote (or abort if none)
    REMOTE=$(${git} remote 2>/dev/null | head -n1)
    if [ -z "$REMOTE" ]; then
      echo "No remote configured in git repository."
      exit 1
    fi

    # Check the head in remote, and switch to it
    REMOTE_DEFAULT=$(${git} remote show $REMOTE | ${awk} '/HEAD branch/ {print $NF}')
    ${git} checkout "$REMOTE_DEFAULT"

    # --- FETCH REMOTE BRANCHES ---
    ${git} fetch "$REMOTE" --prune

    # --- SANITIZE FUNCTION ---
    sanitize() {
      printf '%s' "$1" | ${tr} '[:upper:]' '[:lower:]' | ${sed} 's|[/:]\+|-|g; s|[^a-z0-9:_-]|-|g'
    }

    # --- CREATE WORKTREES FOR REMOTE BRANCHES ---
    ${mkdir} -p worktrees

    # Currently set branch
    CUR_BRANCH=$(${git} symbolic-ref --short HEAD)

    # Do all remote branches
    ${git} for-each-ref --format='%(refname:strip=3)' refs/remotes/"$REMOTE"/ | \
    while read branch; do
      [ "$branch" = "HEAD" ] && continue
      [ "$branch" = "$CUR_BRANCH" ] && continue

      WTNAME=$(sanitize "$branch")
      WTROOT="./worktrees/$WTNAME"

      # If worktree already exists, pull latest changes
      if [ -d "$WTROOT" ]; then
        echo "Worktree $WTROOT already exists, pulling latest changes..."
        (
          cd "$WTROOT"
          ${git} pull "$REMOTE" "$branch"
        )
        continue
      fi

      # If local branch doesn't exist, create it from remote
      if ! ${git} show-ref --verify --quiet "refs/heads/$branch"; then
        ${git} branch "$branch" "$REMOTE/$branch"
      fi

      ${git} worktree add "$WTROOT" "$branch"
    done

    # Do all local branches
    existing_worktree_branches=$(${git} worktree list --porcelain | \
      ${awk} '/^branch / {print $2}' | \
      ${sed} 's|refs/heads/||')

    # For each local branch, create a worktree if missing
    ${git} branch --format='%(refname:short)' | while read branch; do
      # Skip if already in a worktree
      if echo "$existing_worktree_branches" | ${grep} -qx "$branch"; then
        continue
      fi

      # Directory sanitization as before
      sanitized_dir=$(echo "$branch" | \
        ${tr} '[:upper:]' '[:lower:]' | \
        ${sed} 's|[/:]\+|-|g; s|[^a-z0-9:_-]|-|g')
      dir="./worktrees/$sanitized_dir"

      # If worktree already exists, pull latest changes
      if [ -d "$dir" ]; then
        echo "Worktree $dir already exists, pulling latest changes..."
        (
          cd "$dir"
          # Pull from the current tracking branch
          ${git} pull
        )
        continue
      fi

      # Create worktree, if not created yet
      ${git} worktree add "$dir" "$branch"
    done

    echo "All branches now have a sanitized worktree in ./worktrees"
  ''
