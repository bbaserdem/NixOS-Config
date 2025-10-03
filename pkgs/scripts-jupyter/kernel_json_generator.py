#!/usr/bin/env python3
"""
Generate kernel.json files for Jupyter kernels.
"""

import argparse
import json
import os
from pathlib import Path


def generate_wrapper_script(kernel_name: str, python_exe: str, kernel_dir: Path | str, project_dir: Path | str) -> Path:
    """Generate a wrapper script for the kernel."""
    kernel_dir = Path(kernel_dir)
    project_dir = Path(project_dir)
    wrapper_script = kernel_dir / 'kernel-wrapper.sh'

    wrapper_content = f'''#!/bin/bash
# Auto-generated kernel wrapper for {kernel_name}
# Project directory: {project_dir}

export JUPYTER_KERNEL_DIR="{project_dir}"

exec python3 -c "
import sys
sys.path.insert(0, '{os.path.dirname(__file__)}')
from kernel_devshell import main
main()
" --python-exe "{python_exe}" "$@"
'''

    wrapper_script.write_text(wrapper_content)
    wrapper_script.chmod(0o755)
    return wrapper_script


def generate_kernel_json(kernel_dir: Path | str, python_exe: str, display_name: str,
                        wrapper_script: Path | str = None, nix_project_root: Path | str = None) -> Path:
    """Generate kernel.json file."""
    kernel_dir = Path(kernel_dir)
    kernel_json = kernel_dir / 'kernel.json'

    if wrapper_script:
        wrapper_script = Path(wrapper_script)
    if nix_project_root:
        nix_project_root = Path(nix_project_root)

    if wrapper_script and nix_project_root:
        # Generate kernel.json with wrapper script for nix devshell
        kernel_spec = {
            "argv": [str(wrapper_script), "-f", "{connection_file}"],
            "display_name": f"{display_name} (nix)",
            "language": "python",
            "metadata": {
                "venv_path": str(Path(python_exe).parent),
                "nix_project_root": str(nix_project_root),
                "uses_devshell": True
            }
        }
    else:
        # Generate standard kernel.json
        kernel_spec = {
            "argv": [python_exe, "-m", "ipykernel_launcher", "-f", "{connection_file}"],
            "display_name": display_name,
            "language": "python",
            "metadata": {
                "venv_path": str(Path(python_exe).parent)
            }
        }

    with open(kernel_json, 'w') as f:
        json.dump(kernel_spec, f, indent=2)

    return kernel_json


def main():
    parser = argparse.ArgumentParser(description='Generate Jupyter kernel.json files')
    parser.add_argument('kernel_dir', help='Kernel directory path')
    parser.add_argument('python_exe', help='Python executable path')
    parser.add_argument('display_name', help='Kernel display name')
    parser.add_argument('--wrapper-script', help='Path to wrapper script')
    parser.add_argument('--nix-project-root', help='Nix project root directory')
    parser.add_argument('--generate-wrapper', action='store_true', help='Generate wrapper script')
    parser.add_argument('--kernel-name', help='Kernel name (for wrapper generation)')

    args = parser.parse_args()

    kernel_dir = Path(args.kernel_dir)
    kernel_dir.mkdir(parents=True, exist_ok=True)

    wrapper_script = None
    nix_project_root = None

    if args.generate_wrapper and args.kernel_name and args.nix_project_root:
        nix_project_root = Path(args.nix_project_root)
        wrapper_script = generate_wrapper_script(
            args.kernel_name, args.python_exe, kernel_dir, nix_project_root
        )
    elif args.wrapper_script and args.nix_project_root:
        wrapper_script = Path(args.wrapper_script)
        nix_project_root = Path(args.nix_project_root)

    kernel_json = generate_kernel_json(
        kernel_dir, args.python_exe, args.display_name, wrapper_script, nix_project_root
    )

    print(str(kernel_json))


if __name__ == '__main__':
    main()