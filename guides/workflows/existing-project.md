# 📂 Existing Project Migration Guide v2.0

Import existing projects into the AI Workspace v2.0 planning system.

## Quick Migration

```bash
# 1. Create planning structure
ai-plan new existing-project-name

# 2. Link to existing GitHub repository
echo "~/GitHub/username/existing-repo" > \
  ~/ai-workspace/projects/existing-project-name/.deploy-link

# 3. Add workspace link to repo
mkdir -p ~/GitHub/username/existing-repo/.claude
echo "~/ai-workspace/projects/existing-project-name" > \
  ~/GitHub/username/existing-repo/.claude/workspace-link

# 4. Copy CLAUDE configuration
cp ~/ai-workspace/projects/existing-project-name/claude/CLAUDE.md \
   ~/GitHub/username/existing-repo/CLAUDE.md
```

## Detailed Migration Process

### Step 1: Analyze Existing Project

```bash
# Navigate to existing project
cd ~/GitHub/username/existing-project

# Have Claude analyze it
claude-code "Analyze this project and create:
1. Project overview
2. Current architecture
3. Technology stack used
4. Key features implemented
5. Areas for improvement"
```

### Step 2: Create Planning Structure

```bash
# Create AI Workspace planning
ai-plan new existing-project

# This creates:
# projects/existing-project/
# ├── planning/
# │   ├── requirements.md
# │   └── architecture.md
# ├── claude/
# │   ├── CLAUDE.md
# │   └── mcp.json
# └── deploy/
#     └── structure.yaml
```

### Step 3: Document Current State

```bash
cd ~/ai-workspace/projects/existing-project/planning

# Update requirements with current features
claude-code "Document the existing features and requirements of [project]
based on the codebase at ~/GitHub/username/existing-project"

# Document architecture
claude-code "Document the current architecture including:
- System components
- Database schema
- API endpoints
- Frontend structure"
```

### Step 4: Create Project Configuration

Edit `projects/existing-project/claude/CLAUDE.md`:
```markdown
# Project: [Existing Project Name]

## Current State
- Framework: [Current framework]
- Language: [Current language]
- Database: [Current database]

## Migration Goals
- [ ] Add comprehensive tests
- [ ] Improve documentation
- [ ] Refactor legacy code
- [ ] Update dependencies

## Code Conventions
[Document existing conventions found in the code]

## Known Issues
[List any known bugs or technical debt]
```

### Step 5: Configure MCP Servers

Edit `projects/existing-project/claude/mcp.json`:
```json
{
  "extends": "../../global/mcp/default.json",
  "mcpServers": {
    "project-files": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-filesystem"],
      "env": {
        "ALLOWED_DIRECTORIES": "~/GitHub/username/existing-project"
      }
    },
    "project-db": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "${PROJECT_DATABASE_URL}"
      }
    }
  }
}
```

### Step 6: Create Bidirectional Links

```bash
# Link planning to code
echo "~/GitHub/username/existing-project" > \
  ~/ai-workspace/projects/existing-project/.deploy-link

# Link code to planning
mkdir -p ~/GitHub/username/existing-project/.claude
echo "~/ai-workspace/projects/existing-project" > \
  ~/GitHub/username/existing-project/.claude/workspace-link

# Copy CLAUDE.md to project
cp ~/ai-workspace/projects/existing-project/claude/CLAUDE.md \
   ~/GitHub/username/existing-project/CLAUDE.md
```

### Step 7: Extract TODOs

```bash
cd ~/GitHub/username/existing-project

# Find existing TODOs in code
claude-code "Search for all TODO, FIXME, and XXX comments in the code
and create a comprehensive TODO list"

# Save to planning
claude-code "Save the TODO list to
~/ai-workspace/todos/active/existing-project.md"
```

## Migration Patterns

### Node.js/JavaScript Project
```bash
# Analyze package.json
claude-code "Based on package.json, document:
- Dependencies and their purposes
- Scripts and what they do
- Development workflow"

# Extract configuration
claude-code "Find and document all configuration files:
- .env variables needed
- Build configuration
- Deployment settings"
```

### Python Project
```bash
# Analyze requirements
claude-code "Based on requirements.txt or pyproject.toml:
- List all dependencies
- Identify frameworks used
- Document virtual environment setup"

# Document structure
claude-code "Document the Python project structure:
- Module organization
- Entry points
- Configuration management"
```

### Monorepo
```bash
# Create planning for each package
for package in packages/*; do
  name=$(basename $package)
  ai-plan new "monorepo-$name"
done

# Link them together
claude-code "Create a monorepo overview that links all packages"
```

## Advanced Migration

### With Git History Analysis
```bash
cd ~/GitHub/username/existing-project

# Analyze commit history
claude-code "Analyze git history to understand:
- Major features added over time
- Contributors and their focus areas
- Development patterns
- Release cycle"
```

### With Test Coverage Analysis
```bash
# Run existing tests
npm test -- --coverage  # or appropriate test command

# Analyze coverage
claude-code "Based on test coverage:
- Identify untested code
- Suggest additional tests
- Create testing TODO list"
```

### With Dependency Audit
```bash
# Check for vulnerabilities
npm audit  # or pip-audit, etc.

# Plan updates
claude-code "Create a plan to:
- Update vulnerable dependencies
- Migrate deprecated packages
- Modernize the stack"
```

## Post-Migration Workflow

### 1. Activate the Project
```bash
ai-plan activate existing-project
```

### 2. Start Development with Context
```bash
cd ~/GitHub/username/existing-project

# Claude now has:
# - Global rules
# - Project planning
# - Existing code context

claude-code "Help me refactor the authentication system
following our architectural patterns"
```

### 3. Keep Planning Updated
```bash
# After making changes
ai-plan sync existing-project

# Update architecture if needed
claude-code "Update architecture.md based on recent changes"
```

## Common Scenarios

### Legacy Codebase
```bash
# Document technical debt
claude-code "Analyze this legacy code and create:
1. Technical debt inventory
2. Modernization roadmap
3. Refactoring priorities"
```

### Undocumented Project
```bash
# Generate documentation
claude-code "Generate comprehensive documentation:
1. README with setup instructions
2. API documentation
3. Architecture overview
4. Deployment guide"
```

### Multiple Environments
```bash
# Document environments
claude-code "Document all environments:
- Development setup
- Staging configuration
- Production requirements
- Environment variables for each"
```

## Migration Checklist

- [ ] Create planning structure with `ai-plan new`
- [ ] Document current requirements
- [ ] Document current architecture
- [ ] Create project-specific CLAUDE.md
- [ ] Configure MCP servers
- [ ] Create bidirectional links
- [ ] Extract and organize TODOs
- [ ] Test Claude context loading
- [ ] Update global rules if needed
- [ ] Activate project if current focus

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Can't analyze large codebase | Focus on specific directories first |
| Missing dependencies | Run package installer first |
| Complex architecture | Break down into components |
| No documentation | Start with code analysis |
| Multiple repos | Create separate planning for each |

---

**Next Steps**:
- [Daily Development](../use-cases/daily-dev.md) with migrated project
- [Update Global Rules](../../global/rules/) based on project needs
- [Create Project Templates](../../system/templates/) from successful migrations

**Version**: 2.0.0 with bidirectional planning ↔ code linking