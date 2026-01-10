// TRIBE MCP Server - Model Context Protocol integration for Claude Code
package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"strings"
)

// JSON-RPC structures
type Request struct {
	JSONRPC string          `json:"jsonrpc"`
	ID      interface{}     `json:"id"`
	Method  string          `json:"method"`
	Params  json.RawMessage `json:"params,omitempty"`
}

type Response struct {
	JSONRPC string      `json:"jsonrpc"`
	ID      interface{} `json:"id"`
	Result  interface{} `json:"result,omitempty"`
	Error   *Error      `json:"error,omitempty"`
}

type Error struct {
	Code    int    `json:"code"`
	Message string `json:"message"`
}

// MCP Protocol structures
type ServerInfo struct {
	Name    string `json:"name"`
	Version string `json:"version"`
}

type InitializeResult struct {
	ProtocolVersion string     `json:"protocolVersion"`
	ServerInfo      ServerInfo `json:"serverInfo"`
	Capabilities    struct {
		Tools struct{} `json:"tools"`
	} `json:"capabilities"`
}

type Tool struct {
	Name        string      `json:"name"`
	Description string      `json:"description"`
	InputSchema InputSchema `json:"inputSchema"`
}

type InputSchema struct {
	Type       string              `json:"type"`
	Properties map[string]Property `json:"properties"`
	Required   []string            `json:"required,omitempty"`
}

type Property struct {
	Type        string `json:"type"`
	Description string `json:"description"`
}

type ToolsListResult struct {
	Tools []Tool `json:"tools"`
}

type CallToolParams struct {
	Name      string                 `json:"name"`
	Arguments map[string]interface{} `json:"arguments"`
}

type ToolResult struct {
	Content []ContentBlock `json:"content"`
}

type ContentBlock struct {
	Type string `json:"type"`
	Text string `json:"text"`
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	// Increase buffer size for large messages
	buf := make([]byte, 1024*1024)
	scanner.Buffer(buf, len(buf))

	for scanner.Scan() {
		line := scanner.Text()
		if line == "" {
			continue
		}

		var req Request
		if err := json.Unmarshal([]byte(line), &req); err != nil {
			continue
		}

		resp := handleRequest(req)
		output, _ := json.Marshal(resp)
		fmt.Println(string(output))
	}
}

func handleRequest(req Request) Response {
	switch req.Method {
	case "initialize":
		return Response{
			JSONRPC: "2.0",
			ID:      req.ID,
			Result: InitializeResult{
				ProtocolVersion: "2024-11-05",
				ServerInfo: ServerInfo{
					Name:    "tribe-mcp",
					Version: "1.0.0",
				},
			},
		}

	case "tools/list":
		return Response{
			JSONRPC: "2.0",
			ID:      req.ID,
			Result: ToolsListResult{
				Tools: []Tool{
					{
						Name:        "tribe_search",
						Description: "Search across your coding sessions for relevant past work. Use before implementing features to find existing patterns.",
						InputSchema: InputSchema{
							Type: "object",
							Properties: map[string]Property{
								"query": {
									Type:        "string",
									Description: "Search query (e.g., 'authentication middleware', 'docker compose')",
								},
								"limit": {
									Type:        "string",
									Description: "Max results (default: 5)",
								},
							},
							Required: []string{"query"},
						},
					},
					{
						Name:        "tribe_recall",
						Description: "Get a summary of what happened in a specific coding session. Shows files touched, commands run, and key topics.",
						InputSchema: InputSchema{
							Type: "object",
							Properties: map[string]Property{
								"session_id": {
									Type:        "string",
									Description: "Session ID (can be short, e.g., '7347dbe2')",
								},
							},
							Required: []string{"session_id"},
						},
					},
					{
						Name:        "tribe_extract",
						Description: "Extract specific content from a session: code blocks, shell commands, or files touched.",
						InputSchema: InputSchema{
							Type: "object",
							Properties: map[string]Property{
								"session_id": {
									Type:        "string",
									Description: "Session ID",
								},
								"type": {
									Type:        "string",
									Description: "Type to extract: 'code', 'commands', or 'files'",
								},
							},
							Required: []string{"session_id", "type"},
						},
					},
					{
						Name:        "tribe_sessions",
						Description: "List recent coding sessions. Use to find session IDs for recall or extract.",
						InputSchema: InputSchema{
							Type: "object",
							Properties: map[string]Property{
								"limit": {
									Type:        "string",
									Description: "Max sessions to return (default: 10)",
								},
								"project": {
									Type:        "string",
									Description: "Filter by project name",
								},
							},
						},
					},
				},
			},
		}

	case "tools/call":
		var params CallToolParams
		if err := json.Unmarshal(req.Params, &params); err != nil {
			return errorResponse(req.ID, -32602, "Invalid params")
		}
		return handleToolCall(req.ID, params)

	default:
		return errorResponse(req.ID, -32601, "Method not found")
	}
}

func handleToolCall(id interface{}, params CallToolParams) Response {
	var output string
	var err error

	switch params.Name {
	case "tribe_search":
		query, _ := params.Arguments["query"].(string)
		limit := "5"
		if l, ok := params.Arguments["limit"].(string); ok && l != "" {
			limit = l
		}
		output, err = runTribe("search", query, "--limit", limit)

	case "tribe_recall":
		sessionID, _ := params.Arguments["session_id"].(string)
		output, err = runTribe("recall", sessionID)

	case "tribe_extract":
		sessionID, _ := params.Arguments["session_id"].(string)
		extractType, _ := params.Arguments["type"].(string)
		if extractType == "" {
			extractType = "code"
		}
		output, err = runTribe("extract", sessionID, "--type", extractType)

	case "tribe_sessions":
		limit := "10"
		if l, ok := params.Arguments["limit"].(string); ok && l != "" {
			limit = l
		}
		args := []string{"query", "sessions", "--limit", limit}
		if project, ok := params.Arguments["project"].(string); ok && project != "" {
			args = append(args, "--project", project)
		}
		output, err = runTribe(args...)

	default:
		return errorResponse(id, -32602, "Unknown tool: "+params.Name)
	}

	if err != nil {
		output = "Error: " + err.Error()
	}

	return Response{
		JSONRPC: "2.0",
		ID:      id,
		Result: ToolResult{
			Content: []ContentBlock{
				{Type: "text", Text: output},
			},
		},
	}
}

func runTribe(args ...string) (string, error) {
	// Find tribe binary
	tribePath := os.ExpandEnv("$HOME/.tribe/bin/tribe")
	if _, err := os.Stat(tribePath); os.IsNotExist(err) {
		tribePath = "tribe" // Fall back to PATH
	}

	cmd := exec.Command(tribePath, args...)
	out, err := cmd.CombinedOutput()
	return strings.TrimSpace(string(out)), err
}

func errorResponse(id interface{}, code int, message string) Response {
	return Response{
		JSONRPC: "2.0",
		ID:      id,
		Error: &Error{
			Code:    code,
			Message: message,
		},
	}
}
