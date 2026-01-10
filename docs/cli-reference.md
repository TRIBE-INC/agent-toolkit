# TRIBE CLI Reference

Complete reference for all TRIBE CLI commands.

## Global Flags

| Flag | Description |
|------|-------------|
| `--help`, `-h` | Show help for any command |
| `--version`, `-v` | Show CLI version |
| `-verbose` | Enable verbose output |
| `-localhost` | Force localhost mode |

## Authentication Commands

### `tribe login`

Authenticate with TRIBE.

```bash
tribe login
```

Opens browser for authentication. Stores credentials in `~/.tribe/tutor/auth.json`.

### `tribe logout`

Remove authentication.

```bash
tribe logout
```

## Telemetry Commands

### `tribe enable`

Enable telemetry collection.

```bash
tribe enable
```

Starts the background collector for Claude Code, Cursor, etc.

### `tribe disable`

Disable telemetry collection.

```bash
tribe disable
```

Stops the background collector.

### `tribe status`

Show telemetry status.

```bash
tribe status
```

Displays authentication state, collector status, and connection health.

## Knowledge Commands

### `tribe search`

Search across your coding sessions.

```bash
tribe search <query> [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--limit N` | Max results (default: 10) |
| `--format json\|text` | Output format (default: text) |
| `--time-range RANGE` | Time range: 24h, 7d, 30d, 90d, all |
| `--tool NAME` | Filter by tool (Claude Code, Cursor) |
| `--project PATH` | Filter by project (partial match) |

**Examples:**
```bash
tribe search "authentication middleware"
tribe search "docker" --project myapp
tribe search "API endpoint" --time-range 30d
tribe search "testing" --tool "Claude Code" --limit 5
```

### `tribe recall`

Generate a summary of a coding session.

```bash
tribe recall <session-id> [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--format json\|text` | Output format (default: text) |

**Examples:**
```bash
tribe recall 7347dbe2
tribe recall 7347dbe2-8b8e-4edf-92df-0a294de32a82
tribe recall abc123 --format json
```

**Output includes:**
- Project and tool
- Duration and token count
- Files touched
- Commands run
- Tools used
- Key topics

### `tribe extract`

Extract specific content from a session.

```bash
tribe extract <session-id> [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--type TYPE` | Type: code, commands, files, edits (default: code) |
| `--limit N` | Max items (default: 20) |
| `--format json\|text` | Output format (default: text) |

**Examples:**
```bash
tribe extract abc123 --type code
tribe extract abc123 --type commands --limit 10
tribe extract abc123 --type files --format json
tribe extract abc123 --type edits
```

**Types:**
- `code` - Code blocks and snippets
- `commands` - Shell commands executed
- `files` - Files that were touched
- `edits` - File edits made (diffs)

### `tribe query`

Query sessions, events, and insights.

```bash
tribe query <subcommand> [options]
```

**Subcommands:**

#### `tribe query sessions`

List coding sessions.

```bash
tribe query sessions [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--limit N` | Max results (default: 20) |
| `--format json\|text` | Output format |
| `--time-range RANGE` | 24h, 7d, 30d, 90d, all |
| `--tool NAME` | Filter by tool |
| `--project PATH` | Filter by project |

#### `tribe query events`

Get events for a specific session.

```bash
tribe query events --session <id> [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--session ID` | Session ID (required) |
| `--limit N` | Max events (default: 50) |
| `--format json\|text` | Output format |

#### `tribe query insights`

Get AI-generated insights.

```bash
tribe query insights [options]
```

## Session IDs

Session IDs can be:

- **Full UUID**: `7347dbe2-8b8e-4edf-92df-0a294de32a82`
- **Short ID**: `7347dbe2` (first 8 characters)

Short IDs work for all commands. If ambiguous, TRIBE shows matching options.

## Output Formats

### Text (default)

Human-readable formatted output.

### JSON

Machine-readable JSON output, useful for scripting:

```bash
tribe query sessions --format json | jq '.sessions[0]'
tribe recall abc123 --format json > session.json
```

## Environment Variables

| Variable | Description |
|----------|-------------|
| `TRIBE_DASHBOARD_URL` | Override dashboard URL |
| `TRIBE_TUTOR_SERVER_URL` | Override tutor server URL |

## File Locations

| Path | Description |
|------|-------------|
| `~/.tribe/bin/tribe` | CLI binary |
| `~/.tribe/tutor/auth.json` | Authentication credentials |
| `~/.tribe/tutor/insights/` | Local insights cache |

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | Error |
