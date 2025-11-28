#!/usr/bin/env bash
#
# Install git hooks from .githooks directory
# Run this script once after cloning the repository
#

set -e

HOOKS_DIR=".githooks"
GIT_HOOKS_DIR=$(git rev-parse --git-path hooks)

echo "🔗 Installing git hooks from $HOOKS_DIR to $GIT_HOOKS_DIR..."

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Not in a git repository. Please run this from the project root."
    exit 1
fi

# Check if hooks directory exists
if [ ! -d "$HOOKS_DIR" ]; then
    echo "❌ $HOOKS_DIR directory not found."
    exit 1
fi

# Install each hook
for hook in "$HOOKS_DIR"/*; do
    if [ -f "$hook" ] && [ -x "$hook" ]; then
        hook_name=$(basename "$hook")
        # Skip the install script itself
        if [ "$hook_name" != "install-hooks.sh" ]; then
            echo "Installing $hook_name..."
            cp "$hook" "$GIT_HOOKS_DIR/$hook_name"
            chmod +x "$GIT_HOOKS_DIR/$hook_name"
        fi
    fi
done

echo "✅ Git hooks installed successfully!"
echo ""
echo "Installed hooks:"
ls -la "$GIT_HOOKS_DIR" | grep -E "(commit-msg|post-commit)" || echo "No hooks found"
echo ""
echo "💡 Hooks will now validate conventional commits and auto-bump versions"