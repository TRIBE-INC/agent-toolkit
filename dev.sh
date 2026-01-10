#!/bin/bash
# TRIBE Agent Toolkit - Development Loop
# Watch for changes, reinstall, and test interactively

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMANDS_DIR="$HOME/.claude/commands"

# Colors
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

install_skills() {
    for skill_dir in "$SCRIPT_DIR/skills"/*/; do
        skill_name=$(basename "$skill_dir")
        if [ -f "$skill_dir/SKILL.md" ]; then
            cp "$skill_dir/SKILL.md" "$COMMANDS_DIR/$skill_name.md"
        fi
    done
    echo -e "${GREEN}Skills reinstalled${NC}"
}

run_prompt() {
    local prompt="$1"
    echo -e "${CYAN}Running: $prompt${NC}"
    echo "---"
    echo "$prompt" | claude --print --dangerously-skip-permissions 2>&1
    echo "---"
}

show_help() {
    echo ""
    echo "TRIBE Agent Toolkit - Dev Mode"
    echo "=============================="
    echo "Commands:"
    echo "  i, install    - Reinstall skills from source"
    echo "  t, test       - Run full test suite"
    echo "  s, search     - Test tribe-search with custom query"
    echo "  r, recall     - Test tribe-recall with session ID"
    echo "  p, prompt     - Run custom prompt"
    echo "  e, edit       - Open skills in editor"
    echo "  l, list       - List installed skills"
    echo "  h, help       - Show this help"
    echo "  q, quit       - Exit"
    echo ""
}

echo "=========================================="
echo "TRIBE Agent Toolkit - Dev Mode"
echo "=========================================="
echo "Type 'help' for commands"
install_skills

while true; do
    echo ""
    read -p "> " cmd arg

    case "$cmd" in
        i|install)
            install_skills
            ;;
        t|test)
            ./test.sh
            ;;
        s|search)
            if [ -z "$arg" ]; then
                read -p "Search query: " arg
            fi
            install_skills
            run_prompt "Use tribe-search to search for '$arg'"
            ;;
        r|recall)
            if [ -z "$arg" ]; then
                read -p "Session ID: " arg
            fi
            install_skills
            run_prompt "Use tribe-recall to recall session $arg"
            ;;
        p|prompt)
            if [ -z "$arg" ]; then
                read -p "Prompt: " arg
            fi
            install_skills
            run_prompt "$arg"
            ;;
        e|edit)
            ${EDITOR:-vim} "$SCRIPT_DIR/skills/"
            ;;
        l|list)
            echo "Installed skills:"
            ls -la "$COMMANDS_DIR"/tribe*.md 2>/dev/null || echo "  (none)"
            ;;
        h|help)
            show_help
            ;;
        q|quit|exit)
            echo "Bye!"
            exit 0
            ;;
        "")
            # Empty input, just continue
            ;;
        *)
            echo "Unknown command: $cmd (type 'help' for commands)"
            ;;
    esac
done
