"""Main entry point for SkyFi."""

import sys
from typing import NoReturn

from skyfi.cli import app


def main() -> NoReturn:
    """Main entry point for SkyFi CLI."""
    try:
        app()
    except KeyboardInterrupt:
        print("\n[Interrupted by user]")
        sys.exit(130)
    except Exception as e:
        print(f"Unexpected error: {e}", file=sys.stderr)
        sys.exit(1)

    sys.exit(0)


if __name__ == "__main__":
    main()
