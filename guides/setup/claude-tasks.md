# 🤖 Claude Tasks & Automation Guide

Automate repetitive tasks and create reusable workflows with Claude.

## Quick Start

### Create Your First Task
```bash
# Simple prompt template
claude-code "Create a code review prompt template for Python code"

# Task chain for project setup
claude-code "Create a task chain for setting up a new React project"

# Custom automation
claude-code "Create an automation that runs tests before every commit"
```

## Prompt Templates

### Location
`agents/claude-tasks/prompts/`

### Basic Template
```markdown
# Task: [Name]

## Role
You are a [role description]

## Context
[Provide context]

## Instructions
1. [Step 1]
2. [Step 2]

## Input
{variable_to_replace}

## Expected Output
[Describe expected output]
```

### Example Templates

#### Code Review
Save as `agents/claude-tasks/prompts/review.md`:
```markdown
# Code Review

Review this code for:
- Security issues
- Performance problems
- Best practices
- Potential bugs

Code:
{code}

Provide specific line numbers and fixes.
```

Usage:
```bash
claude-code --prompt-file agents/claude-tasks/prompts/review.md
```

#### Test Generation
Save as `agents/claude-tasks/prompts/tests.md`:
```markdown
# Generate Tests

Generate comprehensive tests for:
{code}

Include:
- Unit tests
- Edge cases
- Error handling
- Mocking where needed
```

## Task Chains

### Location
`agents/claude-tasks/chains/`

### Chain Structure
```yaml
name: "Task Chain Name"
description: "What this chain does"
variables:
  - project_name
  - tech_stack

steps:
  - name: "Step 1"
    prompt: "Do something with {project_name}"
    tools: ["Read", "Write"]

  - name: "Step 2"
    prompt: "Do next thing"
    tools: ["Bash"]
    depends_on: "Step 1"
```

### Example Chains

#### Daily Startup
```yaml
name: "Daily Development Startup"
description: "Start your development day"

steps:
  - name: "Check TODOs"
    prompt: "Show all active TODOs sorted by priority"

  - name: "Check Git Status"
    prompt: "Check git status of all projects"
    tools: ["Bash"]

  - name: "Create Daily Plan"
    prompt: "Create a daily plan based on TODOs and priorities"
    tools: ["Write"]
```

#### Feature Development
```yaml
name: "Feature Development"
description: "Complete feature development workflow"

variables:
  - feature_name
  - project_path

steps:
  - name: "Create Branch"
    prompt: "Create feature branch for {feature_name}"
    tools: ["Bash"]

  - name: "Implement Feature"
    prompt: "Implement {feature_name} following project conventions"
    tools: ["Read", "Write", "Edit"]

  - name: "Write Tests"
    prompt: "Write tests for the new feature"
    tools: ["Write"]

  - name: "Update Documentation"
    prompt: "Update docs for {feature_name}"
    tools: ["Edit"]

  - name: "Create PR"
    prompt: "Create pull request for {feature_name}"
    tools: ["Bash"]
```

## Custom Functions

### Location
`agents/claude-tasks/functions/`

### Function Definition
```json
{
  "name": "function_name",
  "description": "What it does",
  "inputs": {
    "param1": "string",
    "param2": "array"
  },
  "outputs": {
    "result": "object"
  },
  "implementation": "prompt or script"
}
```

### Example Functions

#### API Endpoint Generator
```json
{
  "name": "generate_crud_endpoint",
  "description": "Generate CRUD endpoints for a resource",
  "inputs": {
    "resource": "string",
    "fields": "array",
    "database": "string"
  },
  "outputs": {
    "controller": "file",
    "routes": "file",
    "tests": "file"
  },
  "prompt": "Generate CRUD endpoints for {resource} with fields {fields} using {database}"
}
```

## Automation Workflows

### Git Hooks
Create `.git/hooks/pre-commit`:
```bash
#!/bin/bash
claude-code --prompt-file ~/ai-workspace/agents/claude-tasks/prompts/pre-commit-review.md
```

### Scheduled Tasks
Use cron for scheduled tasks:
```bash
# Daily code quality check at 9 AM
0 9 * * * claude-code --chain ~/ai-workspace/agents/claude-tasks/chains/daily-quality.yaml

# Weekly dependency update
0 10 * * 1 claude-code "Check and update project dependencies"
```

### CI/CD Integration
GitHub Actions example:
```yaml
name: AI Code Review
on: [pull_request]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Claude Review
        run: |
          claude-code --prompt "Review PR changes for quality and issues"
```

## Advanced Patterns

### Conditional Chains
```yaml
name: "Smart Deploy"
steps:
  - name: "Run Tests"
    prompt: "Run all tests"
    tools: ["Bash"]

  - name: "Deploy"
    prompt: "Deploy to production"
    tools: ["Bash"]
    condition: "tests_passed"

  - name: "Rollback"
    prompt: "Rollback deployment"
    tools: ["Bash"]
    condition: "deploy_failed"
```

### Interactive Tasks
```yaml
name: "Project Setup Wizard"
steps:
  - name: "Get Requirements"
    prompt: "Ask user about project requirements"
    interactive: true

  - name: "Generate Structure"
    prompt: "Create project based on requirements"
    uses_previous: true
```

### Multi-Model Tasks
```yaml
name: "Complex Analysis"
steps:
  - name: "Quick Analysis"
    prompt: "Quick code scan"
    model: "claude-instant"

  - name: "Deep Analysis"
    prompt: "Detailed architecture review"
    model: "claude-2"
```

## Integration Examples

### With MCP Servers
```yaml
name: "Database Migration"
steps:
  - name: "Backup Database"
    prompt: "Create database backup"
    mcp_server: "postgres"

  - name: "Run Migration"
    prompt: "Execute migration scripts"
    tools: ["Bash"]

  - name: "Verify"
    prompt: "Verify database state"
    mcp_server: "postgres"
```

### With External APIs
```yaml
name: "Deploy and Monitor"
steps:
  - name: "Deploy"
    prompt: "Deploy to AWS"
    mcp_server: "aws"

  - name: "Monitor"
    prompt: "Set up monitoring"
    external_api: "datadog"
```

## Best Practices

1. **Keep Prompts Focused**
   - Single responsibility
   - Clear instructions
   - Specific outputs

2. **Use Variables**
   ```yaml
   variables:
     - project_name
     - environment
   prompt: "Deploy {project_name} to {environment}"
   ```

3. **Chain Related Tasks**
   - Group related operations
   - Define dependencies
   - Handle failures

4. **Version Control**
   ```bash
   cd ~/ai-workspace/agents/claude-tasks
   git init
   git add .
   git commit -m "Initial tasks"
   ```

5. **Test Tasks**
   ```bash
   # Test individual prompt
   claude-code --prompt-file prompts/test.md --dry-run

   # Test chain
   claude-code --chain chains/test.yaml --validate
   ```

## Quick Commands

Add to `~/.zshrc`:
```bash
# Claude task shortcuts
alias ai-review="claude-code --prompt-file $AI_WORKSPACE/agents/claude-tasks/prompts/review.md"
alias ai-test="claude-code --prompt-file $AI_WORKSPACE/agents/claude-tasks/prompts/tests.md"
alias ai-daily="claude-code --chain $AI_WORKSPACE/agents/claude-tasks/chains/daily.yaml"
alias ai-deploy="claude-code --chain $AI_WORKSPACE/agents/claude-tasks/chains/deploy.yaml"
```

---

**Next Steps**:
- Create your first [prompt template](../../agents/claude-tasks/prompts/)
- Build a [task chain](../../agents/claude-tasks/chains/)
- Set up [automation](../workflows/automation.md)