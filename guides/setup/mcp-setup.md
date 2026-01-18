# 🔧 MCP (Model Context Protocol) Setup Guide

Connect Claude to your databases, APIs, and external tools.

## Quick Setup

```bash
# 1. Copy example config
cp ~/ai-workspace/workflows/mcp-configs/example-config.json ~/.config/claude-code/config.json

# 2. Edit with your settings
nano ~/.config/claude-code/config.json

# 3. Test connection
claude-code test-server filesystem
```

## Available MCP Servers

### 📁 Filesystem Access
```json
{
  "filesystem": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-filesystem"],
    "env": {
      "ALLOWED_DIRECTORIES": "/Users/you/ai-workspace,/Users/you/projects"
    }
  }
}
```

### 🔗 GitHub Integration
```json
{
  "github": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-github"],
    "env": {
      "GITHUB_TOKEN": "ghp_your_token_here"
    }
  }
}
```

### 🗄️ PostgreSQL Database
```json
{
  "postgres": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-postgres"],
    "env": {
      "DATABASE_URL": "postgresql://user:password@localhost:5432/dbname"
    }
  }
}
```

### 🍃 MongoDB
```json
{
  "mongodb": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-mongodb"],
    "env": {
      "MONGODB_URI": "mongodb://localhost:27017/mydb"
    }
  }
}
```

### 📊 Google Sheets
```json
{
  "google-sheets": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-google-sheets"],
    "env": {
      "GOOGLE_API_KEY": "your_api_key",
      "SPREADSHEET_ID": "your_spreadsheet_id"
    }
  }
}
```

## Project-Specific Configurations

### Web Development Project
```json
{
  "mcpServers": {
    "project-files": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem"],
      "env": {
        "ALLOWED_DIRECTORIES": "/path/to/frontend,/path/to/backend"
      }
    },
    "database": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

### Data Science Project
```json
{
  "mcpServers": {
    "notebooks": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem"],
      "env": {
        "ALLOWED_DIRECTORIES": "/path/to/notebooks,/path/to/data"
      }
    },
    "database": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "${DATA_WAREHOUSE_URL}"
      }
    },
    "aws": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-aws"],
      "env": {
        "AWS_PROFILE": "data-science"
      }
    }
  }
}
```

### API Development
```json
{
  "mcpServers": {
    "api-code": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem"],
      "env": {
        "ALLOWED_DIRECTORIES": "/path/to/api"
      }
    },
    "dev-db": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "postgresql://localhost/api_dev"
      }
    },
    "test-db": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "postgresql://localhost/api_test"
      }
    },
    "redis": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-redis"],
      "env": {
        "REDIS_URL": "redis://localhost:6379"
      }
    }
  }
}
```

## Environment Variables

### Setting Up .env
Create `~/.config/claude-code/.env`:
```bash
# GitHub
GITHUB_TOKEN=ghp_your_token_here

# Database
DATABASE_URL=postgresql://user:pass@localhost/db
MONGODB_URI=mongodb://localhost:27017/mydb

# AWS
AWS_ACCESS_KEY_ID=your_key
AWS_SECRET_ACCESS_KEY=your_secret
AWS_REGION=us-east-1

# API Keys
OPENAI_API_KEY=sk-...
GOOGLE_API_KEY=...
```

### Using Environment Variables
```json
{
  "github": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-github"],
    "env": {
      "GITHUB_TOKEN": "${GITHUB_TOKEN}"
    }
  }
}
```

## Custom MCP Servers

### Basic Template
Create `workflows/mcp-servers/custom-api.js`:

```javascript
#!/usr/bin/env node
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import axios from 'axios';

const API_BASE = process.env.API_BASE || 'https://api.example.com';
const API_KEY = process.env.API_KEY;

const server = new Server({
  name: 'custom-api',
  version: '1.0.0',
  capabilities: {
    tools: {}
  }
});

// Define tools
server.setRequestHandler('tools/list', async () => ({
  tools: [
    {
      name: 'fetch_user',
      description: 'Fetch user data',
      inputSchema: {
        type: 'object',
        properties: {
          userId: { type: 'string' }
        },
        required: ['userId']
      }
    },
    {
      name: 'create_task',
      description: 'Create a new task',
      inputSchema: {
        type: 'object',
        properties: {
          title: { type: 'string' },
          description: { type: 'string' }
        },
        required: ['title']
      }
    }
  ]
}));

// Implement tool handlers
server.setRequestHandler('tools/call', async (request) => {
  const { name, arguments: args } = request.params;

  switch (name) {
    case 'fetch_user':
      const response = await axios.get(`${API_BASE}/users/${args.userId}`, {
        headers: { 'Authorization': `Bearer ${API_KEY}` }
      });
      return { content: [{ type: 'text', text: JSON.stringify(response.data) }] };

    case 'create_task':
      const task = await axios.post(`${API_BASE}/tasks`, args, {
        headers: { 'Authorization': `Bearer ${API_KEY}` }
      });
      return { content: [{ type: 'text', text: JSON.stringify(task.data) }] };

    default:
      throw new Error(`Unknown tool: ${name}`);
  }
});

// Start server
const transport = new StdioServerTransport();
await server.connect(transport);
```

### Register Custom Server
```json
{
  "custom-api": {
    "command": "node",
    "args": ["~/ai-workspace/workflows/mcp-servers/custom-api.js"],
    "env": {
      "API_BASE": "https://api.mycompany.com",
      "API_KEY": "${MY_API_KEY}"
    }
  }
}
```

## Testing & Debugging

### Test Individual Servers
```bash
# Test filesystem access
claude-code test-server filesystem

# Test with verbose output
claude-code test-server github --verbose

# Test all configured servers
claude-code test-servers
```

### Debug Mode
```bash
# Enable debug logging
export MCP_DEBUG=true
claude-code

# Check server logs
tail -f ~/.config/claude-code/logs/mcp-*.log
```

### Common Issues

| Issue | Solution |
|-------|----------|
| Server fails to start | Check npm/node installation: `npm --version` |
| Permission denied | Verify directory permissions in ALLOWED_DIRECTORIES |
| Database connection failed | Test connection: `psql $DATABASE_URL` |
| Token invalid | Regenerate token and update config |
| Server timeout | Increase timeout in config: `"timeout": 30000` |

## Security Best Practices

### 1. Limit File Access
```json
{
  "filesystem": {
    "env": {
      "ALLOWED_DIRECTORIES": "/specific/project/path",
      "DENY_DIRECTORIES": "/etc,/usr,/bin,/private"
    }
  }
}
```

### 2. Use Read-Only Database Access
```json
{
  "readonly-db": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-postgres"],
    "env": {
      "DATABASE_URL": "postgresql://readonly_user:pass@localhost/db"
    }
  }
}
```

### 3. Rotate Tokens Regularly
```bash
# Script to rotate tokens
#!/bin/bash
NEW_TOKEN=$(gh auth token)
sed -i "s/GITHUB_TOKEN=.*/GITHUB_TOKEN=$NEW_TOKEN/" ~/.config/claude-code/.env
echo "Token rotated: $(date)" >> ~/ai-workspace/logs/token-rotation.log
```

## Advanced Configurations

### Multiple Environments
```json
{
  "dev": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-postgres"],
    "env": {
      "DATABASE_URL": "${DEV_DATABASE_URL}"
    }
  },
  "staging": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-postgres"],
    "env": {
      "DATABASE_URL": "${STAGING_DATABASE_URL}"
    }
  },
  "prod-readonly": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-postgres"],
    "env": {
      "DATABASE_URL": "${PROD_READONLY_URL}"
    }
  }
}
```

### Conditional Loading
```javascript
// In custom server
const ENV = process.env.NODE_ENV || 'development';

if (ENV === 'production') {
  // Load production config
} else {
  // Load development config
}
```

---

**Next Steps**:
- [Create Claude Tasks](claude-tasks.md) for automation
- [Set up custom servers](../../workflows/mcp-servers/) for your APIs
- Test your configuration: `claude-code "List my MCP servers"`