#!/bin/bash
# TRIBE Agent Toolkit - Iterative Test Runner
# Reinstalls skills and runs tests with claude --print

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMANDS_DIR="$HOME/.claude/commands"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=========================================="
echo "TRIBE Agent Toolkit - Test Runner"
echo "=========================================="

# Step 1: Reinstall skills
echo -e "\n${YELLOW}[1/3] Installing skills...${NC}"
for skill_dir in "$SCRIPT_DIR/skills"/*/; do
    skill_name=$(basename "$skill_dir")
    if [ -f "$skill_dir/SKILL.md" ]; then
        cp "$skill_dir/SKILL.md" "$COMMANDS_DIR/$skill_name.md"
        echo "  ✓ $skill_name"
    fi
done

# Step 2: Run tests
echo -e "\n${YELLOW}[2/3] Running tests...${NC}"

PASS=0
FAIL=0

run_test() {
    local name="$1"
    local prompt="$2"
    local expect="$3"

    echo -n "  Testing: $name... "

    # Run claude --print with the prompt
    output=$(echo "$prompt" | claude --print --dangerously-skip-permissions 2>&1 || true)

    # Check if expected string is in output
    if echo "$output" | grep -qi "$expect"; then
        echo -e "${GREEN}PASS${NC}"
        ((PASS++))
        return 0
    else
        echo -e "${RED}FAIL${NC}"
        echo "    Expected to find: $expect"
        echo "    Output (first 200 chars): ${output:0:200}..."
        ((FAIL++))
        return 1
    fi
}

# Test 1: Skills are visible
run_test "skills-visible" \
    "List your tribe-related skills (just the names)" \
    "tribe-search"

# Test 2: tribe-search skill works
run_test "tribe-search-invokes" \
    "Use tribe-search to search for 'test query'. Just run the command." \
    "tribe search"

# Test 3: tribe-recall skill works
run_test "tribe-recall-invokes" \
    "Use tribe-recall to recall session abc123. Just run the command." \
    "tribe recall"

# Test 4: tribe-workflow skill exists
run_test "tribe-workflow-visible" \
    "Do you have a tribe-workflow skill? Answer yes or no." \
    "yes"

# Step 3: Summary
echo -e "\n${YELLOW}[3/3] Results${NC}"
echo "=========================================="
echo -e "  Passed: ${GREEN}$PASS${NC}"
echo -e "  Failed: ${RED}$FAIL${NC}"
echo "=========================================="

if [ $FAIL -eq 0 ]; then
    echo -e "\n${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "\n${RED}Some tests failed.${NC}"
    exit 1
fi
