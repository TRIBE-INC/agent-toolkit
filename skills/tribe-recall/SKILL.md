---
name: tribe-recall
description: Recall context from past TRIBE sessions. Use when you need to understand what was done in a previous session or pull specific content from past work.
---

# TRIBE Recall Skill

Get detailed summaries and extract content from past coding sessions.

## When to Use

- Continuing work from a previous session
- Understanding what was accomplished in past work
- Pulling specific code, commands, or patterns from history
- Building on previous implementations

## Commands

### Recall Session Summary

```bash
tribe recall <session-id>
```

Shows:
- Project and tool used
- Duration and token count
- Files touched
- Commands run
- Tools used
- Key topics

### Extract Specific Content

```bash
# Code blocks and snippets
tribe extract <session-id> --type code

# Shell commands that were executed
tribe extract <session-id> --type commands

# Files that were modified
tribe extract <session-id> --type files

# File edits (diffs)
tribe extract <session-id> --type edits
```

## Finding Session IDs

### From Recent Sessions

```bash
tribe query sessions --limit 10
```

### By Project

```bash
tribe query sessions --project myapp
```

### By Search

```bash
tribe search "what you're looking for"
# Results include session IDs
```

## Short IDs

You can use the first 8 characters of any session ID:

```bash
# Full ID
tribe recall 7347dbe2-8b8e-4edf-92df-0a294de32a82

# Short ID (same result)
tribe recall 7347dbe2
```

## Example Usage

### Continuing Previous Work

```bash
# Find yesterday's session
tribe query sessions --project api-server --time-range 24h

# Recall what was done
tribe recall abc12345

# Extract the commands to continue
tribe extract abc12345 --type commands
```

### Reusing Patterns

```bash
# Search for the pattern
tribe search "webhook handler"

# Found session xyz789, extract the code
tribe extract xyz789 --type code
```

### Understanding Past Decisions

```bash
# Recall the session where auth was implemented
tribe recall auth-session-id

# Review shows:
# - Used JWT with refresh tokens
# - Stored in httpOnly cookies
# - Added rate limiting on login
```

## Output Formats

### JSON Output

```bash
tribe recall <id> --format json
tribe extract <id> --type code --format json
```

Useful for piping to other tools or scripts.
