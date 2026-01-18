# MCP Servers Directory

Model Context Protocol (MCP) server configurations and custom servers for Claude integration.

## What is MCP?

MCP (Model Context Protocol) allows Claude to interact with external tools and data sources through standardized server interfaces.

## Directory Structure

```
mcp-servers/
├── configs/           # Server configuration files
├── custom/           # Custom MCP server implementations
├── logs/            # Server logs and debugging
└── docs/            # Server-specific documentation
```

## MCP Server Types

### Built-in Servers
Claude Code comes with several built-in MCP servers:
- **filesystem** - File system operations
- **github** - GitHub API integration
- **gitlab** - GitLab API integration
- **google-drive** - Google Drive access
- **postgres** - PostgreSQL database access
- **aws** - AWS services integration

### Custom Servers
Create your own MCP servers for:
- Internal APIs
- Custom databases
- Proprietary tools
- Special workflows

## Configuration Files

### Example: claude_code_config.json
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem"],
      "env": {
        "ALLOWED_DIRECTORIES": "/Users/cvences/ai-workspace"
      }
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "your_github_token"
      }
    },
    "custom-api": {
      "command": "node",
      "args": ["./custom/my-api-server.js"],
      "env": {
        "API_KEY": "your_api_key",
        "BASE_URL": "https://api.example.com"
      }
    }
  }
}
```

### Example: Custom MCP Server (custom/my-api-server.js)
```javascript
#!/usr/bin/env node
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';

const server = new Server({
  name: 'custom-api',
  version: '1.0.0',
  capabilities: {
    tools: {},
    resources: {}
  }
});

// Add your custom tools
server.setRequestHandler('tools/list', async () => ({
  tools: [
    {
      name: 'fetch_data',
      description: 'Fetch data from custom API',
      inputSchema: {
        type: 'object',
        properties: {
          endpoint: { type: 'string' }
        }
      }
    }
  ]
}));

// Start the server
const transport = new StdioServerTransport();
await server.connect(transport);
```

## Setting Up MCP Servers

### 1. Install Claude Code
```bash
npm install -g @anthropics/claude-code
```

### 2. Configure MCP Servers
Edit `~/.config/claude-code/config.json` or use:
```bash
claude-code config add-server <server-name>
```

### 3. Test Server Connection
```bash
claude-code test-server <server-name>
```

## Use Cases

### Database Integration
Connect Claude to your databases:
```json
{
  "postgres-prod": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-postgres"],
    "env": {
      "DATABASE_URL": "postgresql://user:pass@localhost/mydb"
    }
  }
}
```

### API Integration
Connect to REST APIs:
```json
{
  "rest-api": {
    "command": "node",
    "args": ["./custom/rest-api-server.js"],
    "env": {
      "API_BASE": "https://api.mycompany.com",
      "API_KEY": "${API_KEY}"
    }
  }
}
```

### File System Access
Control which directories Claude can access:
```json
{
  "workspace": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-filesystem"],
    "env": {
      "ALLOWED_DIRECTORIES": "/Users/cvences/ai-workspace,/Users/cvences/projects"
    }
  }
}
```

## Best Practices

1. **Security:**
   - Use environment variables for sensitive data
   - Limit file system access to specific directories
   - Implement authentication for custom servers

2. **Performance:**
   - Cache frequently accessed data
   - Implement rate limiting
   - Use connection pooling for databases

3. **Error Handling:**
   - Log errors to `logs/` directory
   - Implement graceful fallbacks
   - Provide clear error messages

4. **Documentation:**
   - Document each server's purpose
   - List available tools and resources
   - Provide usage examples

## Debugging

### Enable Debug Logging
```bash
export MCP_DEBUG=true
claude-code
```

### View Server Logs
```bash
tail -f ~/ai-workspace/agents/mcp-servers/logs/server-name.log
```

### Test Individual Servers
```bash
claude-code test-server <server-name> --verbose
```