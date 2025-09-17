# python-kernel-finder: Script to discover Python venvs and register them as Jupyter kernels
{pkgs}: let
  find = "${pkgs.findutils}/bin/find";
  git = "${pkgs.git}/bin/git";
  basename = "${pkgs.coreutils}/bin/basename";
  dirname = "${pkgs.coreutils}/bin/dirname";
  realpath = "${pkgs.coreutils}/bin/realpath";
  mkdir = "${pkgs.coreutils}/bin/mkdir";
  rm = "${pkgs.coreutils}/bin/rm";
  grep = "${pkgs.gnugrep}/bin/grep";
  sed = "${pkgs.gnused}/bin/sed";
  tr = "${pkgs.coreutils}/bin/tr";
  ls = "${pkgs.coreutils}/bin/ls";
in
  pkgs.writeShellScriptBin "python-kernel-finder" ''
    set -euo pipefail

    # Root directory to scan (default to user's Projects folder)
    SCAN_ROOT="''${1:-$HOME/Projects}"

    # Jupyter kernels directory
    JUPYTER_DATA_DIR="''${JUPYTER_DATA_DIR:-$HOME/.local/share/jupyter}"
    KERNELS_DIR="$JUPYTER_DATA_DIR/kernels"

    # Create kernels directory if it doesn't exist
    ${mkdir} -p "$KERNELS_DIR"

    # Function to get git repo name
    get_repo_name() {
      local dir="$1"
      local repo_name=""
      local repo_root

      # Check if it's a git repo (including worktrees)
      if ${git} -C "$dir" rev-parse --git-dir >/dev/null 2>&1; then
        # First try: Get repo name from remote URL
        local remote_url=$(${git} -C "$dir" config --get remote.origin.url 2>/dev/null | ${tr} -d '\n')
        if [ -n "$remote_url" ]; then
          # Extract repo name from remote URL (handles both .git and non-.git URLs)
          repo_name=$(${basename} "$remote_url" .git)
          echo "$repo_name"
          return 0
        fi

        # Second try: For worktrees, get the main repo name from .git file
        if [ -f "$dir/.git" ]; then
          # It's a worktree, parse the .git file to find main repo
          local gitdir=$(${sed} -n 's/^gitdir: //p' "$dir/.git")
          if [ -n "$gitdir" ]; then
            # gitdir format: /path/to/main/repo/.git/worktrees/branch-name
            # We want the main repo name
            local main_repo_dir=$(echo "$gitdir" | ${sed} 's|/\.git/worktrees/.*|/|')
            repo_name=$(${basename} "$main_repo_dir")
            echo "$repo_name"
            return 0
          fi
        fi

        # Final fallback: use toplevel directory name
        repo_root=$(${git} -C "$dir" rev-parse --show-toplevel 2>/dev/null)
        if [ -n "$repo_root" ]; then
          repo_name=$(${basename} "$repo_root")
          echo "$repo_name"
          return 0
        fi
      fi
      return 1
    }

    # Function to check if directory is a git worktree (not main)
    is_worktree() {
      local dir="$1"
      local git_file="$dir/.git"

      # If .git is a file (not directory), it's a worktree
      [ -f "$git_file" ] && return 0
      return 1
    }

    # Function to get branch name
    get_branch_name() {
      local dir="$1"
      ${git} -C "$dir" symbolic-ref --short HEAD 2>/dev/null || echo "detached"
    }

    # Function to create kernel.json
    create_kernel_spec() {
      local venv_path="$1"
      local kernel_name="$2"
      local display_name="$3"
      local kernel_dir="$KERNELS_DIR/$kernel_name"

      # Skip if venv doesn't have Python
      if [ ! -x "$venv_path/bin/python" ]; then
        echo "  Skipping: No python executable found in $venv_path"
        return
      fi

      # Create kernel directory
      ${mkdir} -p "$kernel_dir"

      # Create kernel.json
      cat > "$kernel_dir/kernel.json" <<EOF
    {
      "argv": [
        "$venv_path/bin/python",
        "-m",
        "ipykernel_launcher",
        "-f",
        "{connection_file}"
      ],
      "display_name": "$display_name",
      "language": "python",
      "metadata": {
        "venv_path": "$venv_path"
      }
    }
    EOF

      echo "  Registered kernel: $display_name ($kernel_name)"
    }

    echo "Scanning for Python virtual environments in: $SCAN_ROOT"

    # Clean up existing auto-discovered kernels (those with venv_path in metadata)
    echo "Cleaning up existing auto-discovered kernels..."
    if [ -d "$KERNELS_DIR" ]; then
      for kernel_dir in "$KERNELS_DIR"/*; do
        if [ -d "$kernel_dir" ] && [ -f "$kernel_dir/kernel.json" ]; then
          # Check if this kernel was created by this script (has venv_path in metadata)
          if ${grep} -q '"venv_path"' "$kernel_dir/kernel.json" 2>/dev/null; then
            kernel_name=$(${basename} "$kernel_dir")
            echo "  Removing old kernel: $kernel_name"
            ${rm} -rf "$kernel_dir"
          fi
        fi
      done
    fi
    echo

    # Find all .venv directories (including symlinks)
    ${find} "$SCAN_ROOT" \( -type d -o -type l \) -name ".venv" 2>/dev/null | while read -r venv_path; do
      original_parent="$(${dirname} "$venv_path")"

      # If it's a symlink, resolve it for the actual venv location
      if [ -L "$venv_path" ]; then
        real_venv=$(${realpath} "$venv_path")
        if [ ! -d "$real_venv" ]; then
          echo "  Skipping broken symlink: $venv_path -> $real_venv"
          continue
        fi
        venv_dir="$real_venv"
      else
        venv_dir="$venv_path"
      fi

      # Use original parent for naming, not the resolved path
      parent_dir="$original_parent"

      echo "Found venv: $venv_dir"

      # Try to get repo name
      if repo_name=$(get_repo_name "$parent_dir"); then
        # Check if it's a worktree
        if is_worktree "$parent_dir"; then
          # It's a worktree, get branch name
          branch_name=$(get_branch_name "$parent_dir")
          kernel_name="''${repo_name}-''${branch_name}"
          display_name="''${repo_name}:''${branch_name}"
        else
          # It's main repo
          kernel_name="$repo_name"
          display_name="$repo_name"
        fi
      else
        # Not a git repo, use parent directory name
        parent_name="$(${basename} "$parent_dir")"
        kernel_name="$parent_name"
        display_name="$parent_name"
      fi

      # Sanitize kernel name (alphanumeric, dash, underscore only)
      kernel_name=$(echo "$kernel_name" | ${sed} 's/[^[:alnum:]_-]/-/g' | ${tr} '[:upper:]' '[:lower:]')

      create_kernel_spec "$venv_dir" "$kernel_name" "$display_name"
    done

    echo
    echo "Kernel discovery complete. Found kernels:"
    if [ -d "$KERNELS_DIR" ]; then
      ${ls} -1 "$KERNELS_DIR" 2>/dev/null | while read -r kernel; do
        echo "  $kernel"
      done
    fi
  ''