# 🚀 Quick Start Guide v2.0

Get your AI Workspace v2.0 running in 5 minutes with global/project context separation!

## Prerequisites
- Claude Code CLI installed (`npm install -g @anthropics/claude-code`)
- Git installed
- Text editor (VSCode recommended)

## Step 1: Environment Setup (1 minute)

```bash
# Set workspace variables
echo "export AI_WORKSPACE=$HOME/ai-workspace" >> ~/.zshrc
echo "export GITHUB_DIR=$HOME/GitHub" >> ~/.zshrc

# Add the ai-plan command
echo 'alias ai-plan="$AI_WORKSPACE/system/scripts/ai-plan.sh"' >> ~/.zshrc

# Add helpful aliases
echo 'alias aiw="cd $AI_WORKSPACE"' >> ~/.zshrc
echo 'alias aip="cd $AI_WORKSPACE/projects"' >> ~/.zshrc
echo 'alias aig="cd $GITHUB_DIR"' >> ~/.zshrc

# Reload shell
source ~/.zshrc
```

## Step 2: Configure Claude Code (2 minutes)

```bash
# Create Claude Code config directory
mkdir -p ~/.config/claude-code

# Copy the global MCP configuration
cp $AI_WORKSPACE/global/mcp/default.json ~/.config/claude-code/config.json

# Add your tokens
export GITHUB_TOKEN="your-github-token"
# Add to ~/.zshrc for persistence
```

## Step 3: Test Your Setup (1 minute)

```bash
# Navigate to workspace
aiw

# Test the ai-plan command
ai-plan help

# Test Claude with global context
claude-code "Show me the global rules in my AI workspace"
```

## Step 4: Create Your First Project (2 minutes)

```bash
# Create project planning
ai-plan new my-first-app --type web

# Check what was created
ls -la projects/my-first-app/

# Review the project
ai-plan status my-first-app
```

## Step 5: Deploy to GitHub (1 minute)

```bash
# Deploy project structure
ai-plan deploy my-first-app --github-account yourusername

# Navigate to deployed project
cd ~/GitHub/yourusername/my-first-app

# Start development with full context
claude-code "Show me the context for this project"
```

## Understanding the v2.0 Structure

### Context Hierarchy
1. **Global** (`global/`) - Always loaded, applies to all projects
2. **Project** (`projects/[name]/`) - Loaded when in project
3. **Local** (`~/GitHub/[account]/[repo]/`) - Highest priority

### Key Directories
```
ai-workspace/
├── global/              # Shared rules and MCP servers
│   ├── CLAUDE-GLOBAL.md # Base AI instructions
│   └── rules/          # AGILE, TECH-STACK, SECURITY
├── projects/           # Project planning and configs
│   └── my-app/
│       ├── planning/   # Requirements, architecture
│       └── claude/     # Project-specific AI config
└── system/            # Tools and scripts
    └── scripts/
        └── ai-plan.sh  # Main workflow tool
```

## Workflow Commands

| Command | Purpose | Example |
|---------|---------|---------|
| `ai-plan new` | Start planning | `ai-plan new app-name` |
| `ai-plan architecture` | Design system | `ai-plan architecture app-name` |
| `ai-plan deploy` | Create GitHub repo | `ai-plan deploy app-name` |
| `ai-plan activate` | Set active project | `ai-plan activate app-name` |
| `ai-plan status` | Check project | `ai-plan status app-name` |

## Quick Examples

### Start a Web Project
```bash
ai-plan new todo-app --type web
ai-plan deploy todo-app --github-account myuser
cd ~/GitHub/myuser/todo-app
claude-code "Start building a todo app based on the planning"
```

### Import Existing Project
```bash
# Create planning for existing project
ai-plan new existing-project
# Manually update planning docs
# Link to existing GitHub repo
```

### Update Global Rules
```bash
cd ~/ai-workspace/global/rules
claude-code "Update TECH-STACK.md to add Python FastAPI"
# All projects now inherit this change
```

## What's Next?

✅ **You're ready!** Next steps:

1. **Review Global Rules**: Check `global/rules/` to understand standards
2. **Create a Real Project**: Use `ai-plan new` for your next project
3. **Customize Settings**: Edit global rules to match your preferences
4. **Explore Guides**:
   - [New Project Workflow](../workflows/new-project.md)
   - [MCP Configuration](mcp-setup.md)
   - [Daily Development](../use-cases/daily-dev.md)

## Quick Tips

- 🌍 Global rules apply to ALL projects automatically
- 🚀 Projects can override global rules in their CLAUDE.md
- 🔄 Use `ai-plan sync` to update deployed configs
- 📋 Planning stays in ai-workspace, code goes to GitHub
- 🔗 Bidirectional links keep planning and code connected

## Common Issues

| Problem | Solution |
|---------|----------|
| `ai-plan: command not found` | Run: `source ~/.zshrc` or check alias |
| Can't create project | Check permissions: `chmod +x $AI_WORKSPACE/system/scripts/*.sh` |
| MCP not loading | Verify: `cat ~/.config/claude-code/config.json` |
| Context not loading | Check you're in a project directory with `.claude/` |

---

**Version**: 2.0.0
**Architecture**: Global → Project → Local context hierarchy
**Need help?** Run: `claude-code "Explain the v2.0 AI workspace structure"`