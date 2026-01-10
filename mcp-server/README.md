# TRIBE MCP Server

Model Context Protocol server for direct Claude Code integration.

## Status

🚧 **Coming Soon**

This will provide Claude Code with direct access to TRIBE functions:
- `search_sessions(query)` - Search past coding sessions
- `recall_session(id)` - Get session summary
- `extract_content(id, type)` - Extract code, commands, or files
- `get_project_memory()` - Get project-specific context

## Planned Usage

### Configuration

Add to your Claude Code MCP settings:

```json
{
  "mcpServers": {
    "tribe": {
      "command": "tribe",
      "args": ["mcp", "serve"]
    }
  }
}
```

### Available Tools

Once configured, Claude Code will have access to:

- **tribe_search** - Search sessions for relevant past work
- **tribe_recall** - Recall what happened in a session
- **tribe_extract** - Pull specific content from sessions
- **tribe_context** - Get context for current project

## Development

```bash
# Build MCP server
cd mcp-server
go build -o tribe-mcp .

# Run in development
./tribe-mcp --debug
```

## Contributing

MCP server implementation is tracked in:
- GitHub Issue: #105 (Phase 3)
