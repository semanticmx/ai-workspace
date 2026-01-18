# ⚠️ Workflow Scripts - Migration Notice

## These scripts are from v1.0 and are being replaced by the v2.0 system

### Migration to v2.0

The old workflow scripts (`new-project.sh`, `scan-project.sh`) have been superseded by the new `ai-plan` command system.

## Old vs New Commands

| Old Command (v1.0) | New Command (v2.0) | Description |
|-------------------|-------------------|-------------|
| `./new-project.sh "name"` | `ai-plan new name` | Create new project |
| `./scan-project.sh /path` | `ai-plan new name` + manual import | Import existing project |
| Manual deployment | `ai-plan deploy name` | Deploy to GitHub |
| N/A | `ai-plan architecture name` | Design architecture |
| N/A | `ai-plan activate name` | Set active project |
| N/A | `ai-plan status name` | Check project status |
| N/A | `ai-plan sync name` | Sync configurations |

## New System Location

The new v2.0 scripts are located in:
```
~/ai-workspace/system/scripts/
├── ai-plan.sh          # Main workflow tool
└── load-context.sh     # Context loading system
```

## Setting Up v2.0

```bash
# Add to ~/.zshrc or ~/.bashrc
export AI_WORKSPACE=$HOME/ai-workspace
export GITHUB_DIR=$HOME/GitHub
alias ai-plan="$AI_WORKSPACE/system/scripts/ai-plan.sh"

# Reload
source ~/.zshrc
```

## Key Differences in v2.0

1. **Context Hierarchy**: Global → Project → Local
2. **Planning First**: All projects start in planning phase
3. **Deployment**: Explicit deployment to GitHub
4. **Bidirectional Links**: Planning and code stay connected
5. **Inheritance**: Projects inherit global rules

## Using Old Scripts (Not Recommended)

If you need to use the old scripts temporarily:
```bash
# Still works but doesn't integrate with v2.0 features
./new-project.sh "project-name" "type"
./scan-project.sh /path/to/project
```

## Migrating Old Projects to v2.0

For projects created with v1.0:
```bash
# 1. Create planning structure
ai-plan new old-project-name

# 2. Copy relevant docs to planning
cp ~/ai-workspace/projects/planning/old-project-name-plan.md \
   ~/ai-workspace/projects/old-project-name/planning/

# 3. Link to existing GitHub repo
echo "~/GitHub/user/old-project" > \
   ~/ai-workspace/projects/old-project-name/.deploy-link

# 4. Copy CLAUDE.md to project
cp ~/ai-workspace/projects/old-project-name/claude/CLAUDE.md \
   ~/GitHub/user/old-project/CLAUDE.md

# 5. Create .claude directory
mkdir -p ~/GitHub/user/old-project/.claude
echo "~/ai-workspace/projects/old-project-name" > \
   ~/GitHub/user/old-project/.claude/workspace-link
```

## Documentation

- [v2.0 Quick Start](../../guides/setup/quick-start.md)
- [v2.0 New Project Guide](../../guides/workflows/new-project.md)
- [v2.0 Architecture](../../README.md)

---

**Recommendation**: Use the new `ai-plan` system for all new projects. The v2.0 system provides better organization, context management, and workflow automation.