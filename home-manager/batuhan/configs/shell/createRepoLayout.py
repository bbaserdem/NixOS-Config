"""
Zellij Layout Generator for Git Repositories with Worktrees

This script automatically generates a Zellij layout file that includes:
- A LazyGit tab in the repository root
- Individual tabs for each git worktree with split panes
- Proper handling of both branch and detached HEAD worktrees

Usage: Run this script from anywhere within your git repository
"""

import os
import subprocess


def get_git_root_robust():
    """
    Get the true repository root using git-common-dir method.
    This works correctly with git worktrees, unlike git rev-parse --show-toplevel.
    """
    try:
        git_common_dir = subprocess.check_output(
            ["git", "rev-parse", "--git-common-dir"],
            text=True,
            stderr=subprocess.DEVNULL,
        ).strip()

        if git_common_dir.startswith("/"):
            # Absolute path
            return os.path.realpath(os.path.join(git_common_dir, ".."))
        else:
            # Relative path
            current_dir = os.getcwd()
            return os.path.realpath(os.path.join(current_dir, git_common_dir, ".."))
    except subprocess.CalledProcessError:
        # Fallback to show-toplevel if git-common-dir fails
        return subprocess.check_output(
            ["git", "rev-parse", "--show-toplevel"], text=True
        ).strip()


def get_git_repo_name(git_root):
    """Extract repository name from the root path."""
    return os.path.basename(git_root)


def get_git_worktrees():
    """
    Parse git worktree list --porcelain output and handle both
    branch worktrees and detached HEAD worktrees properly.

    Returns a list of dictionaries with branch_name and branch_dir.
    """
    try:
        output = subprocess.check_output(
            ["git", "worktree", "list", "--porcelain"], text=True
        )
    except subprocess.CalledProcessError as e:
        raise Exception(f"Failed to get git worktree list: {e}")

    worktrees = []
    current_worktree = {}

    for line in output.splitlines():
        line = line.strip()

        if line.startswith("worktree "):
            # New worktree entry - save previous if exists
            if current_worktree:
                worktrees.append(current_worktree)
            current_worktree = {"worktree_path": line[len("worktree ") :].strip()}

        elif line.startswith("HEAD "):
            current_worktree["head_commit"] = line[len("HEAD ") :].strip()

        elif line.startswith("branch "):
            # Extract branch name from refs/heads/branch-name
            branch_ref = line[len("branch ") :].strip()
            if branch_ref.startswith("refs/heads/"):
                current_worktree["branch_name"] = branch_ref[len("refs/heads/") :]
            else:
                current_worktree["branch_name"] = branch_ref

        elif line == "detached":
            # Detached HEAD worktree - use directory name as fallback
            if "worktree_path" in current_worktree:
                dir_name = os.path.basename(current_worktree["worktree_path"])
                current_worktree["branch_name"] = dir_name
                current_worktree["is_detached"] = True

        elif line == "":
            # Empty line indicates end of worktree record
            if current_worktree:
                worktrees.append(current_worktree)
                current_worktree = {}

    # Don't forget the last worktree if there's no trailing empty line
    if current_worktree:
        worktrees.append(current_worktree)

    # Convert to the expected format
    result = []
    for wt in worktrees:
        if "branch_name" in wt and "worktree_path" in wt:
            result.append(
                {
                    "branch_name": wt["branch_name"],
                    "branch_dir": wt["worktree_path"],
                    "is_detached": wt.get("is_detached", False),
                }
            )

    return result


def write_layout_file(git_root, git_repo_name, worktrees, session_title, output_layout):
    """
    Generate the Zellij KDL layout file with default tab template and worktree tabs.
    """
    layout = [
        "layout {",
        '  default_tab_template split_direction="horizontal" {',
        "    pane size=1 borderless=true {",
        '      plugin location="zellij:tab-bar"',
        "    }",
        "    children",
        "    pane size=2 borderless=true {",
        '      plugin location="zellij:status-bar"',
        "    }",
        "  }",
    ]

    # First Tab: LazyGit in git root
    lazygit_tab = f"""  tab name="{git_repo_name} - LazyGit" {{
    pane cwd="{git_root}" {{
      command "lazygit"
    }}
  }}"""
    layout.append(lazygit_tab)

    # Worktree Tabs - each with two vertical panes
    for wt in worktrees:
        tab_name = f"{git_repo_name}:{wt['branch_name']}"
        branch_dir = wt["branch_dir"]
        worktree_tab = f"""  tab name="{tab_name}" {{
    pane split_direction="vertical" {{
      pane cwd="{branch_dir}" {{}}
      pane cwd="{branch_dir}" {{}}
    }}
  }}"""
        layout.append(worktree_tab)

    layout.append("}")

    # Write the layout file
    with open(output_layout, "w") as f:
        f.write("\n".join(layout))


def main():
    """Main function - orchestrate the layout generation process."""
    try:
        print("🔍 Detecting git repository...")
        git_root = get_git_root_robust()
        git_repo_name = get_git_repo_name(git_root)
        session_title = f"{git_repo_name}-session"

        print("📂 Finding git worktrees...")
        worktrees = get_git_worktrees()

        output_layout = f"{git_repo_name}.zellij.kdl"

        print("📝 Generating Zellij layout...")
        write_layout_file(
            git_root, git_repo_name, worktrees, session_title, output_layout
        )

        # Display results
        print("\n" + "=" * 50)
        print("✅ ZELLIJ LAYOUT GENERATED SUCCESSFULLY!")
        print("=" * 50)
        print(f"Session name: {session_title}")
        print(f"Layout file: {output_layout}")
        print(f"Repository: {git_root}")
        print()

        print(f"Found {len(worktrees)} worktrees:")
        for i, wt in enumerate(worktrees, 1):
            detached_indicator = " (detached)" if wt.get("is_detached") else ""
            print(f"  {i}. {wt['branch_name']}{detached_indicator}")
            print(f"     → {wt['branch_dir']}")

        print()
        print("🚀 Start your Zellij session with:")
        print(f'   zellij --session "{session_title}" --layout "{output_layout}"')
        print()

    except subprocess.CalledProcessError as e:
        print(f"❌ Error: Failed to run git command.")
        print(f"   Make sure you're in a git repository and git is installed.")
        print(f"   Details: {e}")
    except Exception as e:
        print(f"❌ Error: {e}")


if __name__ == "__main__":
    main()
