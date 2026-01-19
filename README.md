# 🚀 AI Workspace Command Center v2.0

Centralized planning hub with global/project context separation and GitHub deployment workflow.

## 🏗️ Architecture

```
ai-workspace/
├── 🌍 global/              # Global configs (always loaded)
│   ├── CLAUDE-GLOBAL.md    # Global AI rules
│   ├── rules/              # Development standards
│   └── mcp/                # Shared MCP servers
├── 🚀 projects/            # Project-specific planning
│   └── [project]/
│       ├── planning/       # Requirements & architecture
│       ├── claude/         # Project AI configs
│       └── deploy/         # Deployment configs
├── 📝 todos/               # Manual task tracking
│   ├── active/            # Current TODOs
│   ├── completed/         # Archived TODOs
│   └── blocked/           # Waiting on dependencies
├── 🔗 active-projects/     # Current project links
└── 🛠️ system/             # Tools and automation
    ├── scripts/           # Automation scripts
    └── prompts/           # AI prompt templates
```

## 🎯 Quick Start

### Setup (One-time)
```bash
# Add to ~/.zshrc or ~/.bashrc
export AI_WORKSPACE=$HOME/ai-workspace
export GITHUB_DIR=$HOME/GitHub
alias ai-plan="$AI_WORKSPACE/system/scripts/ai-plan.sh"
alias execute-tasks="$AI_WORKSPACE/system/scripts/execute-tasks.sh"

# Reload shell
source ~/.zshrc
```

### New Project Workflow
```bash
# 1. Create project planning
ai-plan new my-awesome-app --type web

# 2. Edit requirements.md (replace TBD with actual requirements)
vi ~/ai-workspace/projects/my-awesome-app/planning/requirements.md

# 3. Generate project plan from requirements
ai-plan generate my-awesome-app

# 4. Refine architecture (optional)
ai-plan architecture my-awesome-app

# 5. Deploy to GitHub
ai-plan deploy my-awesome-app --github-account myusername

# 6. Start development
cd ~/GitHub/myusername/my-awesome-app
claude-code "Start development with context"

# 7. Execute tasks with TDD (optional)
git checkout -b feature/us-001-description
execute-tasks my-awesome-app us-001
```

### Existing Project Import
```bash
# Import and create planning
./workflows/scripts/scan-project.sh /path/to/existing/project

# Link to planning system
ai-plan new existing-project
# Then manually link the directories
```

## 📋 Context Hierarchy

### 1️⃣ Global Context (Always Active)
- `global/CLAUDE-GLOBAL.md` - Base AI instructions
- `global/rules/AGILE.md` - Agile methodology
- `global/rules/TECH-STACK.md` - Technology standards
- `global/rules/SECURITY.md` - Security requirements
- `global/mcp/default.json` - Shared MCP servers

### 2️⃣ Project Context (When in Project)
- `projects/[name]/claude/CLAUDE.md` - Project overrides
- `projects/[name]/claude/mcp.json` - Project MCP servers
- `projects/[name]/planning/*.md` - Project documentation

### 3️⃣ Local Context (In GitHub Repo)
- `~/GitHub/[account]/[repo]/CLAUDE.md` - Local overrides
- `~/GitHub/[account]/[repo]/.claude/` - Local configs

## 🔄 Workflow Commands

| Command | Description | Example |
|---------|-------------|---------|
| `ai-plan new` | Create project planning | `ai-plan new my-app --type web` |
| `ai-plan generate` | Generate plan from requirements | `ai-plan generate my-app` |
| `ai-plan architecture` | Design architecture | `ai-plan architecture my-app` |
| `ai-plan deploy` | Deploy to GitHub | `ai-plan deploy my-app --github-account user` |
| `ai-plan activate` | Set active project | `ai-plan activate my-app` |
| `ai-plan status` | Show project status | `ai-plan status my-app` |
| `ai-plan sync` | Sync configs | `ai-plan sync my-app` |
| `execute-tasks` | Execute user story tasks with TDD | `execute-tasks my-app us-001` |

## 🗂️ Directory Structure

### Global Configuration
```
global/
├── CLAUDE-GLOBAL.md       # Base AI personality and rules
├── rules/
│   ├── AGILE.md          # Sprint methodology
│   ├── TECH-STACK.md     # Technology choices
│   ├── SECURITY.md       # Security standards
│   └── CODE-STYLE.md     # Coding conventions
└── mcp/
    └── default.json      # Always-available MCP servers
```

### Project Structure
```
projects/my-app/
├── planning/
│   ├── requirements.md   # What to build (starts as TBD, needs editing)
│   ├── architecture.md   # How to build it (generated from requirements)
│   ├── user-stories.md  # User stories (generated from requirements)
│   ├── tasks/           # Task breakdowns per user story
│   └── roadmap.md       # When to build it
├── claude/
│   ├── CLAUDE.md        # Project AI instructions
│   └── mcp.json         # Project MCP servers
└── deploy/
    └── structure.yaml   # Deployment template
```

### Deployed Project
```
~/GitHub/myaccount/my-app/
├── CLAUDE.md            # Copied from planning
├── .claude/
│   ├── workspace-link   # Link to ai-workspace
│   └── project.json     # MCP configuration
├── src/                 # Your code
└── ...                  # Project files
```

## 🤖 Claude Integration

### Context Loading
When Claude starts in a project directory:
1. Loads `global/CLAUDE-GLOBAL.md`
2. Loads all `global/rules/*.md`
3. Loads project-specific `CLAUDE.md`
4. Loads project `planning/*.md` (summaries)
5. Applies MCP server configurations

### MCP Server Priority
1. Global servers (always available)
   - Workspace filesystem access
   - GitHub integration
   - AWS documentation
   - Brave web search (requires API key)
2. Project servers (override/extend global)
3. Local servers (highest priority)

## 📝 Planning → Development Flow

### Phase 1: Planning (ai-workspace)
```bash
ai-plan new my-project --type web
# Edit requirements.md (replace TBD with actual requirements)
ai-plan generate my-project
# Review and refine generated architecture.md, user-stories.md, and tasks/
# Define tech stack
```

### Phase 2: Deployment (GitHub)
```bash
ai-plan deploy my-project --github-account myuser
# Creates ~/GitHub/myuser/my-project/
# Links back to planning
# Copies configurations
```

### Phase 3: Development (GitHub repo)
```bash
cd ~/GitHub/myuser/my-project
claude-code "Implement feature X based on architecture"
# Has full context from planning
# Uses project-specific rules
```

### Phase 4: Sync Changes
```bash
ai-plan sync my-project
# Updates CLAUDE.md in GitHub
# Syncs MCP configurations
```

## 🔧 Configuration Examples

### Global Override
In `projects/my-app/claude/CLAUDE.md`:
```markdown
## Override Global Rules
Unlike global standards, this project:
- Uses Vue instead of React
- Requires 100% test coverage
- Deploys to AWS Lambda
```

### Project MCP Servers
In `projects/my-app/claude/mcp.json`:
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

## 📚 Guides

- [Quick Start](guides/setup/quick-start.md)
- [New Project Setup](guides/workflows/new-project.md)
- [Existing Project Migration](guides/workflows/existing-project.md)
- [MCP Configuration](guides/setup/mcp-setup.md)
- [Claude Tasks](guides/setup/claude-tasks.md)
- [Daily Development](guides/use-cases/daily-dev.md)

## 🎯 Common Tasks

### Start New Feature
```bash
cd ~/GitHub/myuser/my-project
claude-code "Start feature: user authentication
- Check planning docs
- Follow project architecture
- Use defined tech stack"
```

### Review Architecture
```bash
ai-plan architecture my-project
claude-code "Review and improve architecture based on requirements"
```

### Update Global Rules
```bash
cd ~/ai-workspace/global/rules
claude-code "Update TECH-STACK.md to include new framework"
# All projects inherit the change
```

## 🔐 Security Notes

- Never commit `.env` files
- Global rules enforce security standards
- Project-specific secrets in local configs only
- MCP servers use environment variables

## 🚀 Benefits

1. **Clear Separation**: Global vs Project vs Local contexts
2. **Inheritance**: Projects inherit and can override global rules
3. **Bidirectional Links**: Planning ↔ Development stay connected
4. **Consistency**: All projects follow global standards
5. **Flexibility**: Override anything per-project
6. **Traceability**: Requirements → Architecture → Code

---

**Version**: 2.2.0
**Updated**: 2026-01-17
**Status**: Enhanced with TDD task execution and TODO management