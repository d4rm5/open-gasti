# beancount-mcp Integration

This directory contains documentation for MCP (Model Context Protocol) integration.

See [docs/MCP.md](../docs/MCP.md) for the complete setup guide.

## Quick Start

```bash
# Run MCP server
uvx beancount-mcp --transport=stdio ./main.bean

# Or with SSE for remote access
uvx beancount-mcp --transport=sse --port=8080 ./main.bean
```

## Claude Desktop Config

Add to `~/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "beancount": {
      "command": "uvx",
      "args": ["beancount-mcp", "--transport=stdio", "/path/to/main.bean"]
    }
  }
}
```
