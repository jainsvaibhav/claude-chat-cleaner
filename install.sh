#!/usr/bin/env bash
set -e

SKILL_DIR="${HOME}/.claude/skills/chat-cleanup"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing claude-chat-cleaner..."

# Create skill directory
mkdir -p "$SKILL_DIR"

# Copy files
cp "$SCRIPT_DIR/claude-chat-cleaner" "$SKILL_DIR/claude-chat-cleaner"
cp "$SCRIPT_DIR/skills/chat-cleanup/SKILL.md" "$SKILL_DIR/SKILL.md"

# Make CLI executable
chmod +x "$SKILL_DIR/claude-chat-cleaner"

echo ""
echo "Installed to: $SKILL_DIR"
echo ""
echo "Usage:"
echo "  CLI:           ~/.claude/skills/chat-cleanup/claude-chat-cleaner --analyze"
echo "  Claude Code:   /chat-cleanup"
echo ""
echo "Tip: For automatic updates, install as a plugin instead:"
echo "  /plugin marketplace add jainsvaibhav/claude-chat-cleaner"
echo "  /plugin install chat-cleaner@claude-chat-cleaner"
