"""Main entry point for the template package."""

import sys
from typing import Optional


def main(argv: Optional[list[str]] = None) -> int:
    """Main entry point for the template package.
    
    Args:
        argv: Command line arguments (defaults to sys.argv[1:])
        
    Returns:
        Exit code (0 for success)
    """
    args = argv if argv is not None else sys.argv[1:]
    
    if not args:
        print("Hello from template!")
        print("\nThis is a Python project template.")
    else:
        name = " ".join(args)
        print(f"Hello, {name}!")
    
    return 0


if __name__ == "__main__":
    sys.exit(main())