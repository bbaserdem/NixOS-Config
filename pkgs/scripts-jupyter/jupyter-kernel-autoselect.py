"""
Jupyter kernel auto-selection based on project directory.
Automatically selects the appropriate kernel when creating notebooks
based on the presence of .venv in the project hierarchy.
"""
import os
import re
import subprocess
from pathlib import Path


def get_project_kernel(path):
    """Find the appropriate kernel for a given path."""
    current = Path(path).resolve()

    # Walk up the directory tree looking for .venv
    while current != current.parent:
        venv_path = current / '.venv'
        if venv_path.exists():
            # Found a venv, determine kernel name
            project_name = current.name.lower()

            # Check if it's a git worktree
            git_file = current / '.git'
            if git_file.is_file():
                # It's a worktree, get branch name
                try:
                    result = subprocess.run(
                        ['git', '-C', str(current), 'symbolic-ref', '--short', 'HEAD'],
                        capture_output=True, text=True, check=False
                    )
                    if result.returncode == 0:
                        branch = result.stdout.strip()
                        kernel_name = f"{project_name}-{branch}"
                    else:
                        kernel_name = project_name
                except:
                    kernel_name = project_name
            else:
                kernel_name = project_name

            # Sanitize kernel name (match the sanitization in kernel finder)
            kernel_name = re.sub(r'[^a-zA-Z0-9_-]', '-', kernel_name).lower()

            # Check if this kernel exists
            kernel_dir = Path.home() / '.local/share/jupyter/kernels' / kernel_name
            if kernel_dir.exists():
                return kernel_name

        current = current.parent

    # No project-specific kernel found
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