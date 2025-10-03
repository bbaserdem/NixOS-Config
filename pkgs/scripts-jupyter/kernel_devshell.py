#!/usr/bin/env python3
"""
Kernel devshell helper for Jupyter.
Launches Jupyter kernels within nix development environments.
"""

import argparse
import os
import sys
from pathlib import Path


def main():
    parser = argparse.ArgumentParser(description='Launch Jupyter kernel in nix devshell')
    parser.add_argument('-f', '--connection-file', required=True, help='Jupyter connection file')
    parser.add_argument('--python-exe', required=True, help='Python executable path')

    args, extra_args = parser.parse_known_args()

    # Get kernel directory from environment or use current directory
    kernel_dir = Path(os.environ.get('JUPYTER_KERNEL_DIR', os.getcwd()))

    print(f"Kernel helper starting in: {kernel_dir}", file=sys.stderr)
    print(f"Python executable: {args.python_exe}", file=sys.stderr)
    print(f"Connection file: {args.connection_file}", file=sys.stderr)

    # Change to kernel directory
    os.chdir(kernel_dir)

    # Try nix develop first
    print("Attempting nix develop", file=sys.stderr)
    cmd = ['nix', 'develop', '--command', args.python_exe, '-m', 'ipykernel_launcher', '-f', args.connection_file] + extra_args

    try:
        os.execvp(cmd[0], cmd)
    except Exception:
        # Fall back to direct execution
        print("nix develop failed, running kernel directly", file=sys.stderr)
        direct_cmd = [args.python_exe, '-m', 'ipykernel_launcher', '-f', args.connection_file] + extra_args
        os.execvp(direct_cmd[0], direct_cmd)


if __name__ == '__main__':
    main()