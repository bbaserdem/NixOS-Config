#!/usr/bin/env python3
# /// script
# requires-python = ">=3.8"
# dependencies = []
# ///
"""
Post-tool use hook for Claude Code to guide pnpm usage in Node.js/TypeScript projects.

This hook provides helpful guidance when npm commands are used in pnpm projects.
"""

import json
import os
import re
import sys
from pathlib import Path
from typing import Any


class PnpmCommandHandler:
    """Handle Node.js commands with pnpm awareness."""

    def __init__(self):
        self.project_root = Path.cwd()
        self.has_pnpm = self.check_pnpm_available()
        self.in_project = self.check_in_project()

    def check_pnpm_available(self) -> bool:
        """Check if pnpm is available in PATH."""
        return os.system("which pnpm > /dev/null 2>&1") == 0

    def check_in_project(self) -> bool:
        """Check if we're in a Node.js project with package.json."""
        return (self.project_root / "package.json").exists()

    def analyze_command(self, command: str) -> dict[str, Any]:
        """Analyze command to determine how to handle it."""
        # Check if command already uses pnpm
        if command.strip().startswith("pnpm"):
            return {"action": "approve", "reason": "Already using pnpm"}

        # Skip non-Node.js commands entirely
        # Common commands that should never be blocked
        skip_prefixes = [
            "git ",
            "cd ",
            "ls ",
            "cat ",
            "echo ",
            "grep ",
            "find ",
            "mkdir ",
            "rm ",
            "cp ",
            "mv ",
            "curl ",
            "wget ",
            "python",
            "uv ",
            "pip",
        ]
        if any(command.strip().startswith(prefix) for prefix in skip_prefixes):
            return {"action": "approve", "reason": "Not a Node.js command"}

        # Check for actual Node.js package manager commands
        npm_patterns = [
            r"^npm\s+",  # npm commands
            r"\|\s*npm\s+",  # piped to npm
            r";\s*npm\s+",  # after semicolon
            r"&&\s*npm\s+",  # after &&
            r"^npx\s+",  # npx commands
            r"\|\s*npx\s+",  # piped npx
            r";\s*npx\s+",  # after semicolon
            r"&&\s*npx\s+",  # after &&
            r"^yarn\s+",  # yarn commands
            r"\|\s*yarn\s+",  # piped to yarn
            r";\s*yarn\s+",  # after semicolon
            r"&&\s*yarn\s+",  # after &&
        ]

        is_npm_command = any(re.search(pattern, command) for pattern in npm_patterns)

        if not is_npm_command:
            return {"action": "approve", "reason": "Not an npm/yarn command"}

        # If we're in a pnpm project, provide guidance
        if self.has_pnpm and self.in_project:
            # Parse command to provide better suggestions
            suggestion = self.suggest_pnpm_command(command)
            return {
                "action": "block",
                "reason": f"This project uses pnpm for package management. {suggestion}",
            }

        # Otherwise, let it through
        return {"action": "approve", "reason": "pnpm not required"}

    def suggest_pnpm_command(self, command: str) -> str:
        """Provide pnpm command suggestions."""
        # Handle compound commands (e.g., cd && npm install)
        if "&&" in command:
            parts = command.split("&&")
            transformed_parts = []

            for part in parts:
                part = part.strip()
                # Only transform the npm/yarn-related parts
                if re.search(r"\b(npm|npx|yarn)\b", part):
                    transformed_parts.append(self._transform_single_command(part))
                else:
                    transformed_parts.append(part)

            return f"Try: {' && '.join(transformed_parts)}"

        # Simple commands
        return f"Try: {self._transform_single_command(command)}"

    def _transform_single_command(self, command: str) -> str:
        """Transform a single npm/yarn command to use pnpm."""
        # npm install
        if re.match(r"^npm\s+install\s*$", command) or re.match(
            r"^npm\s+i\s*$", command
        ):
            return "pnpm install"

        # npm install <package>
        elif re.match(r"^npm\s+install\s+", command) or re.match(
            r"^npm\s+i\s+", command
        ):
            # Extract package names and flags
            match = re.search(r"^npm\s+(?:install|i)\s+(.+)", command)
            if match:
                args = match.group(1)
                # Check for --save-dev or -D flag
                if "--save-dev" in args or "-D" in args:
                    args = re.sub(r"--save-dev|-D", "-D", args)
                    return f"pnpm add {args}"
                # Check for --global or -g flag
                elif "--global" in args or "-g" in args:
                    args = re.sub(r"--global|-g", "-g", args)
                    return f"pnpm add {args}"
                else:
                    return f"pnpm add {args}"

        # npm uninstall
        elif re.match(r"^npm\s+uninstall\s+", command) or re.match(
            r"^npm\s+remove\s+", command
        ):
            match = re.search(r"^npm\s+(?:uninstall|remove)\s+(.+)", command)
            if match:
                return f"pnpm remove {match.group(1)}"

        # npm run
        elif re.match(r"^npm\s+run\s+", command):
            match = re.search(r"^npm\s+run\s+(.+)", command)
            if match:
                return f"pnpm run {match.group(1)}"

        # npm start/test/etc (scripts)
        elif re.match(r"^npm\s+(start|test|build|dev)\s*", command):
            match = re.search(r"^npm\s+(.+)", command)
            if match:
                return f"pnpm {match.group(1)}"

        # npx commands
        elif re.match(r"^npx\s+", command):
            match = re.search(r"^npx\s+(.+)", command)
            if match:
                return f"pnpm exec {match.group(1)}"

        # yarn commands
        elif re.match(r"^yarn\s+add\s+", command):
            match = re.search(r"^yarn\s+add\s+(.+)", command)
            if match:
                return f"pnpm add {match.group(1)}"

        elif re.match(r"^yarn\s+remove\s+", command):
            match = re.search(r"^yarn\s+remove\s+(.+)", command)
            if match:
                return f"pnpm remove {match.group(1)}"

        elif re.match(r"^yarn\s+install\s*$", command) or re.match(
            r"^yarn\s*$", command
        ):
            return "pnpm install"

        elif re.match(r"^yarn\s+", command):
            # yarn <script> becomes pnpm <script>
            match = re.search(r"^yarn\s+(.+)", command)
            if match:
                return f"pnpm {match.group(1)}"

        # Fallback: just suggest pnpm
        return (
            command.replace("npm", "pnpm")
            .replace("npx", "pnpm exec")
            .replace("yarn", "pnpm")
        )


def main():
    """Main hook function."""
    try:
        # Read input from Claude Code
        input_data = json.loads(sys.stdin.read())

        # Only process Bash/Run commands
        tool_name = input_data.get("tool_name", "")
        if tool_name not in ["Bash", "Run"]:
            # Approve non-Bash tools
            output = {"decision": "approve"}
            print(json.dumps(output))
            return

        # Get the command
        tool_input = input_data.get("tool_input", {})
        command = tool_input.get("command", "")

        if not command:
            # Approve empty commands
            output = {"decision": "approve"}
            print(json.dumps(output))
            return

        # Analyze command
        handler = PnpmCommandHandler()
        result = handler.analyze_command(command)

        # Return decision
        output = {"decision": result["action"], "reason": result["reason"]}

        print(json.dumps(output))

    except Exception as e:
        # On error, approve to avoid blocking workflow
        output = {"decision": "approve", "reason": f"Hook error: {str(e)}"}
        print(json.dumps(output))


if __name__ == "__main__":
    main()
