#!/bin/bash
# TRIBE Agent Toolkit - Skill Installer
# Copies skills to ~/.claude/commands/ for Claude Code integration

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMANDS_DIR="$HOME/.claude/commands"

echo "TRIBE Agent Toolkit - Installing Skills"
echo "========================================"

# Create commands directory if it doesn't exist
mkdir -p "$COMMANDS_DIR"

# Copy skills
for skill_dir in "$SCRIPT_DIR/skills"/*/; do
    skill_name=$(basename "$skill_dir")
    if [ -f "$skill_dir/SKILL.md" ]; then
        cp "$skill_dir/SKILL.md" "$COMMANDS_DIR/$skill_name.md"
        echo "✓ Installed: $skill_name"
    fi
done

echo ""
echo "Done! Skills installed to $COMMANDS_DIR"
echo ""
echo "Available skills:"
echo "  /tribe-search   - Search past sessions"
echo "  /tribe-recall   - Recall session context"
echo "  /tribe-workflow - Complete workflow"
echo ""
echo "Start a new Claude Code session to use them."
