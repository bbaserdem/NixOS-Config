#!/usr/bin/env python3
# /// script
# requires-python = ">=3.8"
# dependencies = []
# ///
"""
Notification hook for pnpm-related reminders.
"""

import json
import sys


def main():
    """Main hook function."""
    try:
        # Read input
        input_data = json.loads(sys.stdin.read())
        message = input_data.get("message", "")

        # Check for Node.js package manager related permission requests
        npm_keywords = [
            "npm",
            "npx",
            "yarn",
            "install package",
            "add package",
            "node_modules",
        ]
        if any(keyword in message.lower() for keyword in npm_keywords):
            reminder = "\n💡 Reminder: Use pnpm commands (pnpm install, pnpm add) instead of npm/yarn directly."

            # Provide context-specific suggestions
            if "install" in message.lower() or "add" in message.lower():
                reminder += "\n   To add packages: pnpm add <package_name>"
                reminder += "\n   To add dev dependencies: pnpm add -D <package_name>"
            if "npx" in message.lower():
                reminder += (
                    "\n   To run packages: pnpm exec <command> or pnpm dlx <package>"
                )
            if "run" in message.lower():
                reminder += "\n   To run scripts: pnpm run <script> or pnpm <script>"

            print(reminder, file=sys.stderr)

        sys.exit(0)

    except Exception as e:
        print(f"Notification hook error: {str(e)}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
