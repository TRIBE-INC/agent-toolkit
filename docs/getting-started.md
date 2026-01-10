# Getting Started with TRIBE

This guide will help you set up TRIBE and start building tribal knowledge from your coding sessions.

## Prerequisites

- Node.js 18 or later
- A terminal/shell
- Claude Code, Cursor, or another supported AI coding tool

## Installation

### Option 1: NPX (Recommended)

```bash
npx @_xtribe/cli@latest
```

This downloads and runs the TRIBE CLI. It will install to `~/.tribe/bin/tribe`.

### Option 2: Direct Download

```bash
curl -fsSL https://tribecode.ai/install.sh | bash
```

### Verify Installation

```bash
tribe --version
```

## Setup

### 1. Authenticate

```bash
tribe login
```

This opens your browser to authenticate with TRIBE. Your credentials are stored locally in `~/.tribe/tutor/auth.json`.

### 2. Enable Telemetry

```bash
tribe enable
```

This starts the background collector that captures your coding sessions.

### 3. Verify Status

```bash
tribe status
```

You should see:
```
TRIBE Status
━━━━━━━━━━━━━━━━━━━━━━━━
✅ Authenticated
✅ Collector running
✅ Connected to tribecode.ai
```

## Your First Search

After some coding sessions, try searching:

```bash
tribe query sessions --limit 5
```

This shows your recent sessions. Each has an ID you can use with other commands.

## Basic Commands

### List Sessions

```bash
tribe query sessions
tribe query sessions --limit 10
tribe query sessions --project myapp
tribe query sessions --time-range 7d
```

### Search Content

```bash
tribe search "authentication"
tribe search "docker compose"
tribe search "API endpoint" --project backend
```

### Recall Session

```bash
tribe recall <session-id>
tribe recall abc12345  # Short IDs work
```

### Extract Content

```bash
tribe extract <session-id> --type code
tribe extract <session-id> --type commands
tribe extract <session-id> --type files
```

## Installing Claude Code Skills

To integrate TRIBE into your Claude Code workflow:

### Option 1: Copy Skills

```bash
# From the agent-toolkit directory
cp skills/*.md ~/.claude/skills/
```

### Option 2: Manual Add

1. Open Claude Code settings
2. Go to Skills
3. Add each skill from the `skills/` directory

## Troubleshooting

### "Not authenticated"

Run `tribe login` again to refresh your credentials.

### "Collector not running"

```bash
tribe disable
tribe enable
```

### "No sessions found"

Sessions appear after you use Claude Code (or other tools) with the collector running. Give it a few minutes after your first session.

### Check Logs

```bash
tribe logs
```

## Next Steps

1. **Use the search skill** - Add `skills/tribe-search.md` to Claude Code
2. **Try the workflow** - Follow `skills/tribe-workflow.md` for a complete process
3. **Explore examples** - Check the `examples/` directory for real-world usage

## Getting Help

- CLI help: `tribe --help`
- Command help: `tribe <command> --help`
- Issues: https://github.com/TRIBE-INC/agent-toolkit/issues
