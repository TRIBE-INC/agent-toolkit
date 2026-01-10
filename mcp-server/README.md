# TRIBE MCP Server

Model Context Protocol server that gives Claude Code direct access to your tribal knowledge.

## Installation

### Build from Source

```bash
cd mcp-server
go build -o tribe-mcp .
```

### Install to PATH

```bash
cp tribe-mcp ~/.tribe/bin/
```

## Configuration

Add to your Claude Code MCP settings (`~/.claude/mcp.json`):

```json
{
  "mcpServers": {
    "tribe": {
      "command": "~/.tribe/bin/tribe-mcp"
    }
  }
}
```

Or if tribe-mcp is in your PATH:

```json
{
  "mcpServers": {
    "tribe": {
      "command": "tribe-mcp"
    }
  }
}
```

## Available Tools

Once configured, Claude Code has access to:

### `tribe_search`

Search across your coding sessions for relevant past work.

**Parameters:**
- `query` (required): Search query (e.g., "authentication middleware")
- `limit` (optional): Max results (default: 5)

**Example:** "Search for how we implemented rate limiting"

### `tribe_recall`

Get a summary of what happened in a specific coding session.

**Parameters:**
- `session_id` (required): Session ID (can use short form like "7347dbe2")

**Example:** "Recall session abc12345 to see what was done"

### `tribe_extract`

Extract specific content from a session.

**Parameters:**
- `session_id` (required): Session ID
- `type` (required): "code", "commands", or "files"

**Example:** "Extract the shell commands from session xyz789"

### `tribe_sessions`

List recent coding sessions.

**Parameters:**
- `limit` (optional): Max sessions (default: 10)
- `project` (optional): Filter by project name

**Example:** "Show my recent sessions for the api-server project"

## Requirements

- TRIBE CLI installed (`~/.tribe/bin/tribe`)
- Authenticated with TRIBE (`tribe login`)
- Telemetry enabled (`tribe enable`)

## Testing

Test the MCP server manually:

```bash
echo '{"jsonrpc":"2.0","id":1,"method":"initialize"}' | ./tribe-mcp
echo '{"jsonrpc":"2.0","id":2,"method":"tools/list"}' | ./tribe-mcp
```

## How It Works

The MCP server:
1. Receives JSON-RPC requests from Claude Code
2. Translates them to TRIBE CLI commands
3. Returns results in MCP format

This gives Claude Code seamless access to your coding history without leaving the conversation.
