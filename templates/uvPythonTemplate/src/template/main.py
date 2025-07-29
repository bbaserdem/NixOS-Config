#!/usr/bin/env python3
"""Main entry point for the template package."""

import argparse
import logging
import sys
from typing import Optional

from . import __package_name__, __version__

# Configure logging
logger = logging.getLogger(__name__)


def setup_logging(verbosity: int) -> None:
    """Configure logging based on verbosity level."""
    log_levels = {
        0: logging.WARNING,
        1: logging.INFO,
        2: logging.DEBUG,
    }
    level = log_levels.get(min(verbosity, 2), logging.DEBUG)

    logging.basicConfig(
        level=level,
        format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
    )


def parse_args(args: Optional[list[str]] = None) -> argparse.Namespace:
    """Parse command line arguments."""
    parser = argparse.ArgumentParser(
        prog=__package_name__,
        description="A template Python project",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )

    parser.add_argument(
        "--version",
        action="version",
        version=f"{__package_name__} {__version__}",
    )

    parser.add_argument(
        "-v",
        "--verbose",
        action="count",
        default=0,
        help="Increase verbosity (can be repeated: -v, -vv, -vvv)",
    )

    parser.add_argument(
        "name",
        nargs="?",
        default="World",
        help="Name to greet (default: World)",
    )

    return parser.parse_args(args)


def main(args: Optional[list[str]] = None) -> int:
    """Main entry point for the template command."""
    try:
        parsed_args = parse_args(args)
        setup_logging(parsed_args.verbose)

        logger.debug("Starting %s v%s", __package_name__, __version__)
        logger.info("Verbose mode enabled") if parsed_args.verbose else None

        # Main functionality
        print(f"Hello, {parsed_args.name}!")
        print(f"This is {__package_name__} v{__version__}")

        logger.debug("Completed successfully")
        return 0

    except KeyboardInterrupt:
        print("\nInterrupted by user", file=sys.stderr)
        return 130
    except Exception as e:
        logger.exception("Unexpected error: %s", e)
        return 1


if __name__ == "__main__":
    sys.exit(main())
