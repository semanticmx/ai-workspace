# 📚 Guides Directory

Comprehensive documentation for AI Workspace v2.0.

## Quick Links

### 🚀 Getting Started
- [**Quick Start**](setup/quick-start.md) - Get running in 5 minutes
- [**Initial Setup**](setup/initial-setup.md) - Complete environment setup
- [**MCP Configuration**](setup/mcp-setup.md) - Connect databases and APIs
- [**Claude Tasks**](setup/claude-tasks.md) - Automation setup

### 💼 Workflows
- [**New Project**](workflows/new-project.md) - Start from scratch with v2.0
- [**Existing Project**](workflows/existing-project.md) - Migrate to v2.0
- [**Project Templates**](workflows/project-templates.md) - Reusable structures
- [**Design Integration**](workflows/design-integration.md) - Visual assets

### 📊 Use Cases
- [**Daily Development**](use-cases/daily-dev.md) - Day-to-day workflow
- [**Code Reviews**](use-cases/code-reviews.md) - AI-assisted reviews
- [**Documentation**](use-cases/documentation.md) - Auto-generate docs
- [**Testing**](use-cases/testing.md) - Test automation

### ⚙️ Advanced
- [**Configuration**](advanced/configuration.md) - Deep customization
- [**Automation**](advanced/automation.md) - Scripts and CI/CD
- [**Best Practices**](best-practices.md) - Tips and patterns
- [**Troubleshooting**](troubleshooting.md) - Common issues

## v2.0 Key Features

### Context Hierarchy
```
Global → Project → Local
```
- **Global**: Rules for all projects
- **Project**: Specific overrides
- **Local**: Implementation details

### Workflow Commands
```bash
ai-plan new my-project
ai-plan architecture my-project
ai-plan deploy my-project
ai-plan activate my-project
ai-plan status my-project
```

### Directory Structure
```
guides/
├── setup/          # Initial configuration
├── workflows/      # Development processes
├── use-cases/      # Practical examples
└── advanced/       # Deep dives
```

## Guide Categories

### Setup Guides
For initial configuration and environment setup:
- Environment variables
- MCP server configuration
- Claude integration
- Tool installation

### Workflow Guides
Step-by-step processes:
- Project creation
- Architecture design
- Deployment pipeline
- Migration paths

### Use Case Guides
Real-world scenarios:
- Feature development
- Bug fixing
- Refactoring
- Performance optimization

### Advanced Guides
Deep technical topics:
- Custom MCP servers
- Complex automations
- Multi-project management
- Enterprise setup

## Contributing Guides

### Creating New Guides
1. Choose appropriate category
2. Use markdown format
3. Include practical examples
4. Add to this README

### Guide Template
```markdown
# Guide Title

## Overview
Brief description

## Prerequisites
- Required knowledge
- Required tools

## Steps
1. Step one
2. Step two

## Examples
Practical code examples

## Troubleshooting
Common issues

## Next Steps
Related guides
```

## Quick Reference

| Task | Guide |
|------|-------|
| First time setup | [Quick Start](setup/quick-start.md) |
| Create new project | [New Project](workflows/new-project.md) |
| Import existing code | [Migration](workflows/existing-project.md) |
| Configure database | [MCP Setup](setup/mcp-setup.md) |
| Daily workflow | [Daily Dev](use-cases/daily-dev.md) |

## Version History

- **v2.0.0** - Context hierarchy, ai-plan system
- **v1.0.0** - Initial workspace structure

---

**Current Version**: 2.0.0
**Last Updated**: 2024
**Feedback**: Create issue in guides/feedback/