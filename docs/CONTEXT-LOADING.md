# 📖 Context Loading System

This document explains how Claude sessions load and apply context from the AI Workspace.

## Overview

The context loading system automatically provides Claude with relevant rules, configurations, and project-specific information based on your current location and project context.

## Context Hierarchy

Context is loaded in layers, with later layers able to override earlier ones:

```
1. Global Context (Always loaded)
   ├── CLAUDE-GLOBAL.md     # Base configuration
   └── rules/              # All rule files
       ├── AGILE.md       # Sprint methodology
       ├── SECURITY.md    # Security standards
       └── TECH-STACK.md  # Technology choices

2. Project Context (When in a project)
   ├── projects/[name]/claude/CLAUDE.md  # Project overrides
   └── projects/[name]/planning/*.md     # Planning docs (first 50 lines)

3. Local Context (When in a repository)
   └── CLAUDE.md  # Local overrides in current directory
```

## How It Works

### Automatic Loading

The `system/scripts/load-context.sh` script automatically loads:

1. **Global Configuration** (`global/CLAUDE-GLOBAL.md`)
   - Core principles and standards
   - Default technology preferences
   - AI assistance guidelines

2. **Global Rules** (`global/rules/*.md`)
   - AGILE.md - Sprint methodology and workflow
   - SECURITY.md - Security requirements and best practices
   - TECH-STACK.md - Technology stack and tooling preferences

3. **Project Context** (when applicable)
   - Project-specific CLAUDE.md overrides
   - Planning documents (requirements, architecture, user stories)

4. **Local Context** (when applicable)
   - Repository-specific CLAUDE.md in current directory

### Load Order and Priority

```
Global Context
    ↓
Global Rules
    ↓
Project Context (if in project)
    ↓
Local Context (if CLAUDE.md exists)
```

Later contexts can override earlier ones.

## Usage Examples

### Starting Claude with Full Context

```bash
# From anywhere - gets global context + rules
claude-code "Start a new task"

# From a project directory - gets global + project context
cd ~/GitHub/myuser/my-project
claude-code "Implement new feature"
```

### Checking Loaded Context

```bash
# View all loaded context
./system/scripts/load-context.sh context

# View only MCP configuration
./system/scripts/load-context.sh mcp

# View both context and MCP
./system/scripts/load-context.sh all
```

### Manual Context Loading

If you need to manually ensure context is loaded:

```bash
# Load specific rule file
claude-code "Apply the rules from ~/ai-workspace/global/rules/SECURITY.md"

# Load all global rules
claude-code "Load all rules from ~/ai-workspace/global/rules/"
```

## Context Files Explained

### CLAUDE-GLOBAL.md
- **Purpose**: Base configuration for all Claude sessions
- **Contains**: Core principles, development standards, technology preferences
- **Location**: `global/CLAUDE-GLOBAL.md`
- **When loaded**: Always

### Rule Files (global/rules/)
- **AGILE.md**: Sprint planning, user stories, task management
- **SECURITY.md**: Security requirements, OWASP guidelines, best practices
- **TECH-STACK.md**: Preferred technologies, frameworks, tools
- **When loaded**: Always (as of latest update)

### Project CLAUDE.md
- **Purpose**: Project-specific overrides and instructions
- **Location**: `projects/[name]/claude/CLAUDE.md`
- **When loaded**: When working in that project's directory
- **Use cases**: Custom tech stack, specific patterns, project conventions

### Local CLAUDE.md
- **Purpose**: Repository-specific instructions
- **Location**: In repository root
- **When loaded**: When Claude is run from that directory
- **Use cases**: Local development setup, team conventions

## Customization

### Adding New Global Rules

1. Create a new `.md` file in `global/rules/`:
   ```bash
   vi ~/ai-workspace/global/rules/MY-RULE.md
   ```

2. The rule will be automatically loaded in all future Claude sessions

### Project-Specific Overrides

1. Edit the project's CLAUDE.md:
   ```bash
   vi ~/ai-workspace/projects/my-project/claude/CLAUDE.md
   ```

2. Add overrides:
   ```markdown
   ## Project Overrides

   Unlike global rules, this project:
   - Uses Vue.js instead of React
   - Requires 100% test coverage
   - Deploys to AWS Lambda
   ```

### Disabling Rules

To disable a global rule for a project, explicitly override it:

```markdown
# In projects/my-project/claude/CLAUDE.md

## Disabled Rules
- Ignoring AGILE.md - This project uses Kanban instead
- Ignoring TECH-STACK.md frontend section - Using Vue.js
```

## Integration with MCP Servers

MCP (Model Context Protocol) servers are configured separately but follow the same hierarchy:

1. **Global MCP**: `global/mcp/default.json`
2. **Project MCP**: `projects/[name]/claude/mcp.json`
3. **Local MCP**: `.claude/project.json`

## Troubleshooting

### Context Not Loading

1. Check script permissions:
   ```bash
   chmod +x ~/ai-workspace/system/scripts/load-context.sh
   ```

2. Verify file locations:
   ```bash
   ls -la ~/ai-workspace/global/
   ls -la ~/ai-workspace/global/rules/
   ```

3. Test context loading:
   ```bash
   ~/ai-workspace/system/scripts/load-context.sh context
   ```

### Rules Not Being Applied

1. Verify rules are being loaded:
   ```bash
   ./system/scripts/load-context.sh context | grep "GLOBAL RULES"
   ```

2. Check for project overrides that might be conflicting

3. Manually load rules to test:
   ```bash
   claude-code "Show me the loaded AGILE rules"
   ```

## Best Practices

1. **Keep Global Rules General**: Put universally applicable rules in global/
2. **Project Specifics in Project Config**: Use project CLAUDE.md for overrides
3. **Document Overrides**: Always explain why you're overriding global rules
4. **Version Control**: Track changes to context files in git
5. **Regular Updates**: Review and update rules based on team learnings

## Version History

- **v2.1.0** (2026-01-17): Added automatic loading of all global rule files
- **v2.0.0**: Initial context hierarchy system

---

For more information, see:
- [Quick Start Guide](../guides/setup/quick-start.md)
- [MCP Configuration](../guides/setup/mcp-setup.md)
- [Claude Tasks](../guides/setup/claude-tasks.md)