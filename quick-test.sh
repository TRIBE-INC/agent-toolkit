#!/bin/bash
# Quick test: reinstall skills and run a prompt
# Usage: ./quick-test.sh "your prompt here"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMANDS_DIR="$HOME/.claude/commands"

# Reinstall skills silently
for skill_dir in "$SCRIPT_DIR/skills"/*/; do
    skill_name=$(basename "$skill_dir")
    [ -f "$skill_dir/SKILL.md" ] && cp "$skill_dir/SKILL.md" "$COMMANDS_DIR/$skill_name.md"
done

# Run prompt
PROMPT="${1:-List your tribe skills}"
echo "$PROMPT" | claude --print --dangerously-skip-permissions 2>&1
