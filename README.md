# TRIBE Agent Toolkit

Connect your AI coding assistant to your team's collective knowledge. TRIBE captures your coding sessions and makes them searchable, so you never solve the same problem twice.

## Quick Start

### 1. Install TRIBE CLI

```bash
npx @_xtribe/cli@latest
```

### 2. Authenticate

```bash
tribe login
```

### 3. Enable Telemetry

```bash
tribe enable
```

### 4. Install the Plugin

Install the TRIBE toolkit plugin in Claude Code:

```bash
claude plugins install tribe-toolkit@local --path /path/to/agent-toolkit
```

Or clone and install from GitHub:

```bash
git clone https://github.com/TRIBE-INC/agent-toolkit.git
claude plugins install tribe-toolkit@local --path ./agent-toolkit
```

## What's Included

### Skills (`skills/`)

Claude Code skills that integrate TRIBE into your workflow:

| Skill | Description |
|-------|-------------|
| `tribe-search` | Search past sessions before solving problems |
| `tribe-recall` | Recall context from previous work |
| `tribe-workflow` | Complete workflow for using tribal knowledge |

### Examples (`examples/`)

Real-world examples showing TRIBE in action:

- `search-before-coding.md` - Find past solutions before writing new code
- `continuing-previous-work.md` - Resume work from a previous session

### Documentation (`docs/`)

- `getting-started.md` - Installation and setup guide
- `cli-reference.md` - Complete CLI command reference
- `best-practices.md` - Tips for building tribal knowledge

## Core Commands

```bash
# Search across all your coding sessions
tribe search "authentication middleware"

# Recall what happened in a session
tribe recall 7347dbe2

# Extract specific content
tribe extract 7347dbe2 --type commands
tribe extract 7347dbe2 --type code
tribe extract 7347dbe2 --type files

# List recent sessions
tribe query sessions --limit 10

# Filter by project or tool
tribe query sessions --project myapp --tool "Claude Code"
```

## How It Works

1. **Capture**: TRIBE runs in the background, capturing your Claude Code sessions
2. **Store**: Sessions are securely stored with full-text search indexing
3. **Search**: Find relevant past work with natural language queries
4. **Recall**: Pull context from past sessions into current work

## Requirements

- Node.js 18+
- Claude Code (or other supported AI coding tool)
- TRIBE account (free tier available)

## License

MIT
