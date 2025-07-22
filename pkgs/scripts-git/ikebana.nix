# git-ikebana: Push all local branches (icluding all worktrees) to their remote
{pkgs}: let
  git = "${pkgs.git}/bin/git";
  grep = "${pkgs.gnugrep}/bin/grep";
  head = "${pkgs.coreutils}/bin/head";
  sed = "${pkgs.gnused}/bin/sed";
  tr = "${pkgs.coreutils}/bin/tr";
in
  pkgs.writeShellScriptBin "git-ikebana" ''
    set -e

    # Find repository root
    REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
    cd "$REPO_ROOT" || exit 1

    # Get canonical origin remote (fallback on first remote if origin does not exist)
    REMOTE=$(${git} remote | ${grep} '^origin$' || ${git} remote | ${head} -n1)
    if [ -z "$REMOTE" ]; then
      echo "No git remote configured in this repo."
      exit 1
    fi

    # --- Push all local branches ---
    echo "Pushing all local branches to $REMOTE ..."
    ${git} for-each-ref --format='%(refname:strip=2)' refs/heads/ | while read branch; do
      echo "> git push $REMOTE $branch"
      ${git} push "$REMOTE" "$branch"
    done

    # --- Push all worktree branches (including possibly detached HEADs) ---
    # Find all worktree paths, including main
    ${git} worktree list --porcelain | awk '
      BEGIN { p = "" }
      /^worktree / { p = substr($0, 10) }
      /^branch / { b = substr($0, 8); print p "|" b }
    ' | while IFS="|" read wtpath wtbranch; do
      if [ -n "$wtbranch" ]; then
        # Remove refs/heads/ prefix, if present
        branch=$(echo "$wtbranch" | ${sed} 's#^refs/heads/##')
        # Already pushed above? (If so, skip)
        # (Branches are only repeated if checked-out in multiple worktrees)
        # Push anyway for safety
        echo "> (worktree:$wtpath) ${git} push $REMOTE $branch"
        ${git} -C "$wtpath" push "$REMOTE" "$branch"
      else
        # Handle detached HEAD state
        echo "> (worktree:$wtpath) [detached HEAD, skipped]"
      fi
    done

    echo "All committed local and worktree branches are pushed."
  '';
