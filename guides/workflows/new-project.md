# 🆕 New Project Setup Guide v2.0

Complete workflow for starting new projects with AI Workspace v2.0's planning → development pipeline.

## Quick Start

```bash
# Complete new project setup in 3 commands
ai-plan new my-app --type web
ai-plan architecture my-app
ai-plan deploy my-app --github-account yourusername
```

## Detailed Workflow

### Phase 1: Project Planning 📋

#### Create Project Structure
```bash
ai-plan new [project-name] --type [web|api|cli|ml]
```

This creates:
```
projects/[project-name]/
├── planning/
│   ├── requirements.md    # Define what to build
│   └── architecture.md    # Define how to build
├── claude/
│   ├── CLAUDE.md          # Project AI rules
│   └── mcp.json           # Project MCP servers
└── deploy/
    └── structure.yaml     # Deployment template
```

#### Define Requirements
Edit `projects/[project-name]/planning/requirements.md`:
```markdown
# Requirements: [Project Name]

## User Stories
- As a user, I want...

## Functional Requirements
- Must have feature X
- Should support Y

## Non-Functional Requirements
- Performance: < 3s load time
- Security: OAuth2 authentication
- Scale: Support 10k concurrent users
```

### Phase 2: Architecture Design 🏗️

```bash
ai-plan architecture [project-name]
```

Then use Claude to help design:
```bash
claude-code "Help me design architecture for [project-name]
- Read requirements
- Suggest tech stack
- Create system design
- Define API structure"
```

### Phase 3: Project Configuration 🔧

#### Override Global Rules (Optional)
Edit `projects/[project-name]/claude/CLAUDE.md`:
```markdown
# Project: [Name]

## Override Global Tech Stack
Unlike global preference for React, this project uses:
- Vue 3 with Composition API
- Pinia for state management

## Project-Specific Patterns
- Use repository pattern for data access
- Implement CQRS for complex operations
```

#### Configure Project MCP
Edit `projects/[project-name]/claude/mcp.json`:
```json
{
  "extends": "../../global/mcp/default.json",
  "mcpServers": {
    "project-db": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "postgresql://localhost/myapp"
      }
    }
  }
}
```

### Phase 4: Deploy to GitHub 🚀

```bash
ai-plan deploy [project-name] --github-account [username]
```

This creates:
```
~/GitHub/[username]/[project-name]/
├── CLAUDE.md              # Copied from planning
├── .claude/
│   ├── workspace-link     # Link back to planning
│   └── project.json       # MCP configuration
├── src/                   # Code directories
├── tests/
├── docs/
└── README.md
```

### Phase 5: Start Development 💻

```bash
cd ~/GitHub/[username]/[project-name]

# Claude now has full context:
# - Global rules
# - Project planning
# - Project-specific overrides

claude-code "Start implementing based on architecture"
```

## Project Types

### Web Application
```bash
ai-plan new my-web-app --type web

# Creates structure for:
# - React/Vue/Next.js frontend
# - Node.js/Python backend
# - PostgreSQL database
# - Docker deployment
```

### API Service
```bash
ai-plan new my-api --type api

# Creates structure for:
# - RESTful/GraphQL API
# - Database models
# - Authentication
# - API documentation
```

### CLI Tool
```bash
ai-plan new my-cli --type cli

# Creates structure for:
# - Command-line interface
# - Configuration management
# - Plugin system
# - Distribution setup
```

### Machine Learning
```bash
ai-plan new my-ml-project --type ml

# Creates structure for:
# - Jupyter notebooks
# - Data pipeline
# - Model training
# - API serving
```

## Advanced Features

### Set Active Project
```bash
# Make a project the current focus
ai-plan activate my-app

# Now accessible via symlink
cd ~/ai-workspace/active-projects/current
```

### Check Project Status
```bash
ai-plan status my-app

# Shows:
# - Planning location
# - Deployment status
# - Active status
# - Last modified
```

### Sync Configuration
```bash
# Update deployed project with latest configs
ai-plan sync my-app

# Syncs:
# - CLAUDE.md
# - MCP configuration
# - Project links
```

## Project Examples

### Full-Stack SaaS
```bash
# Create planning
ai-plan new saas-platform --type web

# Edit requirements
claude-code "Create comprehensive requirements for a SaaS platform with:
- User authentication
- Subscription billing
- Admin dashboard
- API access"

# Design architecture
ai-plan architecture saas-platform
claude-code "Design microservices architecture for SaaS platform"

# Deploy and start
ai-plan deploy saas-platform --github-account mycompany
```

### Microservices API
```bash
# Plan services
ai-plan new user-service --type api
ai-plan new payment-service --type api
ai-plan new notification-service --type api

# Create shared configuration
claude-code "Create shared MCP config for microservices with:
- Shared database
- Message queue
- Service discovery"
```

### Data Pipeline
```bash
# Create project
ai-plan new etl-pipeline --type ml

# Define requirements
claude-code "Create requirements for ETL pipeline:
- Ingest from multiple sources
- Transform and validate
- Load to data warehouse
- Schedule with Airflow"
```

## Best Practices

### 1. Always Start with Planning
```bash
# Don't skip planning phase
ai-plan new project
# Spend time on requirements
# Design before coding
```

### 2. Leverage Context Inheritance
```bash
# Global: General rules
# Project: Specific overrides
# Local: Implementation details

# Check active context:
claude-code "Show me all active context and rules"
```

### 3. Keep Planning Updated
```bash
# As project evolves, update planning
cd ~/ai-workspace/projects/my-app/planning
claude-code "Update architecture based on new requirements"

# Sync to deployed project
ai-plan sync my-app
```

### 4. Use Project Templates
```bash
# Create reusable templates
cp -r projects/successful-app projects/template-web

# Use for new projects
cp -r projects/template-web projects/new-app
ai-plan deploy new-app
```

## Integration with CI/CD

### GitHub Actions
In deployed project, create `.github/workflows/ai-assist.yml`:
```yaml
name: AI-Assisted Development
on: [push, pull_request]

jobs:
  ai-review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Load AI Context
        run: |
          # Context from .claude/workspace-link
          cat CLAUDE.md
      - name: Run AI Review
        run: |
          claude-code "Review changes for compliance with project standards"
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Project already exists | Use different name or delete existing |
| Can't deploy | Check GitHub directory permissions |
| Context not loading | Verify `.claude/workspace-link` exists |
| MCP not working | Check `global/mcp/default.json` syntax |

---

**Next Steps**:
- Review [Global Rules](../../global/rules/) to understand defaults
- Check [Project Templates](../../system/templates/) for examples
- Read [Daily Development](../use-cases/daily-dev.md) for ongoing work

**Version**: 2.0.0 with planning → development pipeline