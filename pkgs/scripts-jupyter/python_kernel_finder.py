#!/usr/bin/env python3
"""
Python kernel finder: Discover Python venvs and register them as Jupyter kernels.
"""

import argparse
import json
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path


def get_git_repo_name(directory: Path) -> str | None:
    """Get git repository name from directory."""
    try:
        # Check if it's a git repo
        subprocess.run(
            ["git", "-C", str(directory), "rev-parse", "--git-dir"],
            capture_output=True,
            check=True,
        )

        # Try to get remote URL
        try:
            result = subprocess.run(
                ["git", "-C", str(directory), "config", "--get", "remote.origin.url"],
                capture_output=True,
                check=True,
                text=True,
            )
            remote_url = result.stdout.strip()
            if remote_url:
                # Extract repo name from URL
                repo_name = Path(remote_url).name
                if repo_name.endswith(".git"):
                    repo_name = repo_name[:-4]
                return repo_name
        except subprocess.CalledProcessError:
            pass

        # For worktrees, check .git file
        git_file = directory / ".git"
        if git_file.is_file():
            content = git_file.read_text().strip()
            for line in content.splitlines():
                if line.startswith("gitdir: "):
                    gitdir = line[8:].strip()  # Remove 'gitdir: ' prefix
                    gitdir_path = Path(gitdir)

                    # The gitdir points to something like: /path/to/main/repo/.git/worktrees/branch
                    # Parse the path to find where .git is located
                    parts = gitdir_path.parts
                    for i, part in enumerate(parts):
                        if part == ".git":
                            # Found .git directory, main repo is the parent
                            main_repo_parts = parts[:i]
                            if main_repo_parts:
                                main_repo_path = Path(*main_repo_parts)
                                return main_repo_path.name
                    break

        # Fallback: use toplevel directory name
        result = subprocess.run(
            ["git", "-C", str(directory), "rev-parse", "--show-toplevel"],
            capture_output=True,
            check=True,
            text=True,
        )
        repo_root = result.stdout.strip()
        if repo_root:
            return Path(repo_root).name

    except subprocess.CalledProcessError:
        pass

    return None


def is_git_worktree(directory: Path) -> bool:
    """Check if directory is a git worktree (not main repo)."""
    git_file = directory / ".git"
    return git_file.is_file()


def get_branch_name(directory: Path) -> str:
    """Get current git branch name."""
    try:
        result = subprocess.run(
            ["git", "-C", str(directory), "symbolic-ref", "--short", "HEAD"],
            capture_output=True,
            check=True,
            text=True,
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError:
        return "detached"


def test_nix_develop(directory: Path) -> bool:
    """Test if nix develop works in the given directory."""
    try:
        # Test nix develop with a simple command
        result = subprocess.run(
            ["nix", "develop", "--command", "echo", "test"],
            cwd=directory,
            capture_output=True,
            timeout=20,
        )
        return result.returncode == 0
    except (subprocess.TimeoutExpired, subprocess.SubprocessError, FileNotFoundError):
        return False


def sanitize_kernel_name(name: str) -> str:
    """Sanitize kernel name to alphanumeric, dash, underscore only."""
    sanitized = re.sub(r"[^a-zA-Z0-9_-]", "-", name)
    return sanitized.lower()


def create_kernel_spec(
    venv_path: Path,
    kernel_name: str,
    display_name: str,
    parent_dir: Path,
    kernels_dir: Path,
) -> None:
    """Create kernel specification."""
    python_exe = venv_path / "bin" / "python"

    # Skip if venv doesn't have Python
    if not python_exe.is_file() or not os.access(python_exe, os.X_OK):
        print(f"  Skipping: No python executable found in {venv_path}")
        return

    kernel_dir = kernels_dir / kernel_name
    kernel_dir.mkdir(parents=True, exist_ok=True)

    # Test if nix develop works in the parent directory
    if test_nix_develop(parent_dir):
        print(f"  Nix develop works in: {parent_dir}")

        # Generate kernel with devshell wrapper
        cmd = [
            sys.executable,
            "-c",
            f'''
import sys
sys.path.insert(0, "{Path(__file__).parent}")
from kernel_json_generator import generate_kernel_json, generate_wrapper_script
wrapper_script = generate_wrapper_script("{kernel_name}", "{python_exe}", "{kernel_dir}", "{parent_dir}")
generate_kernel_json("{kernel_dir}", "{python_exe}", "{display_name}", wrapper_script, "{parent_dir}")
''',
        ]
        subprocess.run(cmd, check=True)
        print(f"  Registered nix devshell kernel: {display_name} (nix) ({kernel_name})")
    else:
        # Generate standard kernel
        cmd = [
            sys.executable,
            "-c",
            f'''
import sys
sys.path.insert(0, "{Path(__file__).parent}")
from kernel_json_generator import generate_kernel_json
generate_kernel_json("{kernel_dir}", "{python_exe}", "{display_name}")
''',
        ]
        subprocess.run(cmd, check=True)
        print(f"  Registered kernel: {display_name} ({kernel_name})")


def clean_old_kernels(kernels_dir: Path) -> None:
    """Clean up existing auto-discovered kernels."""
    print("Cleaning up existing auto-discovered kernels...")

    if not kernels_dir.exists():
        return

    for kernel_dir in kernels_dir.iterdir():
        if not kernel_dir.is_dir():
            continue

        kernel_json = kernel_dir / "kernel.json"
        if not kernel_json.exists():
            continue

        try:
            with open(kernel_json) as f:
                spec = json.load(f)

            # Check if this kernel was created by this script
            if "venv_path" in spec.get("metadata", {}):
                print(f"  Removing old kernel: {kernel_dir.name}")
                shutil.rmtree(kernel_dir)

        except (json.JSONDecodeError, KeyError):
            continue


def find_venvs(scan_root: Path) -> list[Path]:
    """Find all .venv directories."""
    venvs = []

    for venv_path in scan_root.rglob(".venv"):
        if venv_path.is_dir() or venv_path.is_symlink():
            venvs.append(venv_path)

    return venvs


def main():
    parser = argparse.ArgumentParser(
        description="Discover Python virtual environments for Jupyter"
    )
    parser.add_argument("scan_root", nargs="?", help="Root directory to scan")

    args = parser.parse_args()

    # Root directory to scan
    if args.scan_root:
        scan_root = Path(args.scan_root)
    else:
        scan_root = Path.home() / "Projects"

    # Jupyter kernels directory
    jupyter_data_dir = Path(
        os.environ.get("JUPYTER_DATA_DIR", Path.home() / ".local" / "share" / "jupyter")
    )
    kernels_dir = jupyter_data_dir / "kernels"
    kernels_dir.mkdir(parents=True, exist_ok=True)

    print(f"Scanning for Python virtual environments in: {scan_root}")

    # Clean up existing kernels
    clean_old_kernels(kernels_dir)
    print()

    # Find and process venvs
    venvs = find_venvs(scan_root)

    for venv_path in venvs:
        # Handle symlinks
        if venv_path.is_symlink():
            real_venv = venv_path.resolve()
            if not real_venv.exists():
                print(f"  Skipping broken symlink: {venv_path} -> {real_venv}")
                continue
            venv_dir = real_venv
        else:
            venv_dir = venv_path

        # Use original parent for naming
        parent_dir = venv_path.parent

        print(f"Found venv: {venv_dir}")

        # Determine kernel name and display name
        repo_name = get_git_repo_name(parent_dir)
        if repo_name:
            if is_git_worktree(parent_dir):
                # It's a worktree, get branch name
                branch_name = get_branch_name(parent_dir)
                kernel_name = f"{repo_name}-{branch_name}"
                display_name = f"{repo_name}:{branch_name}"
            else:
                # It's main repo
                kernel_name = repo_name
                display_name = repo_name
        else:
            # Not a git repo, use parent directory name
            parent_name = parent_dir.name
            kernel_name = parent_name
            display_name = parent_name

        # Sanitize kernel name
        kernel_name = sanitize_kernel_name(kernel_name)

        create_kernel_spec(venv_dir, kernel_name, display_name, parent_dir, kernels_dir)

    print()
    print("Kernel discovery complete. Found kernels:")
    if kernels_dir.exists():
        for kernel in sorted(kernels_dir.iterdir()):
            if kernel.is_dir():
                print(f"  {kernel.name}")


if __name__ == "__main__":
    main()

