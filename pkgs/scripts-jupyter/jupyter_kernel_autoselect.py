"""
Jupyter kernel auto-selection based on project directory.
Automatically selects the appropriate kernel when creating notebooks
based on the presence of .venv in the project hierarchy.
"""
import os
import re
import subprocess
from pathlib import Path


def get_project_kernel(path, debug=False):
    """Find the appropriate kernel for a given path."""
    current = Path(path).resolve()

    if debug:
        print(f"DEBUG: Starting search from: {current}")

    # Walk up the directory tree looking for .venv
    while current != current.parent:
        venv_path = current / '.venv'
        if venv_path.exists():
            if debug:
                print(f"DEBUG: Found .venv at: {venv_path}")

            # Remember the directory containing the .venv
            venv_parent = current
            git_file = venv_parent / '.git'
            project_name = None
            is_worktree = False

            if debug:
                print(f"DEBUG: Checking git file: {git_file}")
                print(f"DEBUG: Is file: {git_file.is_file()}, Is dir: {git_file.is_dir()}")

            # Determine if it's a worktree and get the project name
            if git_file.is_file():
                # It's a worktree, parse .git file to get main repo name
                is_worktree = True
                if debug:
                    print(f"DEBUG: Detected as worktree!")

                try:
                    with open(git_file, 'r') as f:
                        content = f.read()
                        if debug:
                            print(f"DEBUG: .git file content: {content.strip()}")

                        for line in content.splitlines():
                            if line.startswith('gitdir: '):
                                gitdir = line.replace('gitdir: ', '').strip()
                                if debug:
                                    print(f"DEBUG: gitdir: {gitdir}")

                                # gitdir format: /path/to/main/repo/.git/worktrees/branch-name
                                # Extract the main repo path
                                main_repo_path = gitdir.split('/.git/worktrees/')[0]
                                project_name = Path(main_repo_path).name.lower()

                                if debug:
                                    print(f"DEBUG: Main repo path: {main_repo_path}")
                                    print(f"DEBUG: Project name: {project_name}")
                                break
                except Exception as e:
                    if debug:
                        print(f"DEBUG: Error parsing .git file: {e}")
                    pass
            elif git_file.is_dir():
                # It's a main repo, use its directory name
                project_name = venv_parent.name.lower()
                if debug:
                    print(f"DEBUG: Main repo, project name: {project_name}")

            # Fallback: use venv parent directory name
            if not project_name:
                project_name = venv_parent.name.lower()
                if debug:
                    print(f"DEBUG: Using fallback project name: {project_name}")

            if debug:
                print(f"DEBUG: is_worktree: {is_worktree}")

            # Build kernel name based on whether it's a worktree
            if is_worktree:
                # Get branch name
                if debug:
                    print(f"DEBUG: Getting branch name for worktree...")

                try:
                    result = subprocess.run(
                        ['git', '-C', str(venv_parent), 'symbolic-ref', '--short', 'HEAD'],
                        capture_output=True, text=True, check=False
                    )
                    if debug:
                        print(f"DEBUG: git symbolic-ref result: '{result.stdout.strip()}' (code: {result.returncode})")

                    if result.returncode == 0 and result.stdout.strip():
                        branch = result.stdout.strip()
                        kernel_name = f"{project_name}-{branch}"
                        if debug:
                            print(f"DEBUG: Building kernel name: {project_name}-{branch}")
                    else:
                        # Try alternative method to get branch name
                        result = subprocess.run(
                            ['git', '-C', str(venv_parent), 'rev-parse', '--abbrev-ref', 'HEAD'],
                            capture_output=True, text=True, check=False
                        )
                        if debug:
                            print(f"DEBUG: git rev-parse result: '{result.stdout.strip()}' (code: {result.returncode})")

                        if result.returncode == 0 and result.stdout.strip():
                            branch = result.stdout.strip()
                            kernel_name = f"{project_name}-{branch}"
                            if debug:
                                print(f"DEBUG: Building kernel name: {project_name}-{branch}")
                        else:
                            kernel_name = project_name
                            if debug:
                                print(f"DEBUG: Could not get branch, using: {project_name}")
                except Exception as e:
                    if debug:
                        print(f"DEBUG: Error getting branch: {e}")
                    kernel_name = project_name
            else:
                kernel_name = project_name
                if debug:
                    print(f"DEBUG: Not a worktree, kernel name: {kernel_name}")

            # Sanitize kernel name (match the sanitization in kernel finder)
            kernel_name = re.sub(r'[^a-zA-Z0-9_-]', '-', kernel_name).lower()

            if debug:
                print(f"DEBUG: Final sanitized kernel name: {kernel_name}")

            # Check if this kernel exists
            kernel_dir = Path.home() / '.local/share/jupyter/kernels' / kernel_name
            if kernel_dir.exists():
                if debug:
                    print(f"DEBUG: Kernel exists at: {kernel_dir}")
                return kernel_name
            else:
                if debug:
                    print(f"DEBUG: Kernel does not exist at: {kernel_dir}")
                return None

        current = current.parent

    # No project-specific kernel found
    if debug:
        print(f"DEBUG: No .venv found in directory hierarchy")
    return None


def setup_kernel_autoselect(c):
    """
    Setup kernel auto-selection in Jupyter configuration.
    Call this function from your jupyter_server_config.py with:

        import sys
        sys.path.append('/path/to/this/module')
        from jupyter_kernel_autoselect import setup_kernel_autoselect
        setup_kernel_autoselect(c)
    """
    try:
        from notebook.services.contents.filemanager import FileContentsManager

        original_new = FileContentsManager.new

        def custom_new(self, model=None, path=""):
            if model and model.get('type') == 'notebook':
                # Get the directory where the notebook is being created
                notebook_dir = os.path.join(self.root_dir, path)

                # Find appropriate kernel
                project_kernel = get_project_kernel(notebook_dir)

                if project_kernel:
                    # Set the kernel in the notebook metadata
                    if 'content' in model and model['content'] is not None:
                        if 'metadata' not in model['content']:
                            model['content']['metadata'] = {}
                        if 'kernelspec' not in model['content']['metadata']:
                            model['content']['metadata']['kernelspec'] = {
                                'name': project_kernel,
                                'display_name': project_kernel
                            }

            return original_new(self, model, path)

        FileContentsManager.new = custom_new
        print(f"Jupyter kernel auto-selection enabled")

    except ImportError as e:
        print(f"Could not setup kernel auto-selection: {e}")