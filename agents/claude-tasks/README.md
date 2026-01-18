# Claude Tasks Directory

Store and manage Claude-specific task definitions, prompts, and workflows.

## Directory Structure

```
claude-tasks/
├── prompts/          # Reusable prompt templates
├── chains/           # Multi-step task workflows
├── functions/        # Custom function definitions
├── results/          # Task execution results
└── schedules/        # Scheduled task configurations
```

## Task Types

### 1. Single Prompts (prompts/)
Reusable prompt templates for common tasks:

#### Example: Code Review Prompt
```markdown
# Code Review Template

Review the following code for:
1. Security vulnerabilities
2. Performance issues
3. Best practices violations
4. Potential bugs

Code to review:
{code}

Provide:
- Severity rating (Critical/High/Medium/Low)
- Specific line numbers
- Suggested fixes
- Overall recommendations
```

### 2. Task Chains (chains/)
Multi-step workflows that Claude can execute:

#### Example: Project Setup Chain
```yaml
name: "React Project Setup"
description: "Complete setup for a new React project"
steps:
  - name: "Initialize project"
    prompt: "Create a new React project with TypeScript"
    tools: ["Bash", "Write"]

  - name: "Setup structure"
    prompt: "Create folder structure for components, hooks, utils"
    tools: ["Bash"]

  - name: "Install dependencies"
    prompt: "Install and configure ESLint, Prettier, testing libraries"
    tools: ["Bash", "Edit"]

  - name: "Create components"
    prompt: "Create base components: Layout, Header, Footer"
    tools: ["Write"]

  - name: "Setup routing"
    prompt: "Configure React Router with basic routes"
    tools: ["Write", "Edit"]
```

### 3. Custom Functions (functions/)
Define complex operations as reusable functions:

#### Example: API Generator Function
```json
{
  "name": "generate_crud_api",
  "description": "Generate complete CRUD API for a resource",
  "parameters": {
    "resource_name": "string",
    "fields": "array",
    "database": "postgres|mongodb|mysql",
    "authentication": "jwt|oauth|basic"
  },
  "outputs": [
    "models/{resource_name}.js",
    "controllers/{resource_name}.js",
    "routes/{resource_name}.js",
    "tests/{resource_name}.test.js"
  ],
  "steps": [
    "Create model with validations",
    "Generate controller with CRUD operations",
    "Setup routes with middleware",
    "Write comprehensive tests"
  ]
}
```

## Claude Code Integration

### Using Tasks with Claude Code CLI

#### 1. Execute a saved prompt:
```bash
claude-code --prompt-file ~/ai-workspace/agents/claude-tasks/prompts/code-review.md
```

#### 2. Run a task chain:
```bash
claude-code --chain ~/ai-workspace/agents/claude-tasks/chains/project-setup.yaml
```

#### 3. Use in conversation:
```
You: Please use the "React Project Setup" chain from my tasks
Claude: I'll execute the React Project Setup chain from your saved tasks...
```

## Task Results Storage

### Results Organization (results/)
```
results/
├── 2024-01-17/
│   ├── task-001-code-review/
│   │   ├── input.md
│   │   ├── output.md
│   │   └── metadata.json
│   └── task-002-api-generation/
│       ├── generated-files/
│       ├── logs.txt
│       └── summary.md
```

## Scheduled Tasks (schedules/)

### Example: Daily Code Analysis
```json
{
  "name": "Daily Code Quality Check",
  "schedule": "0 9 * * *",
  "task": {
    "type": "chain",
    "file": "chains/code-quality-check.yaml"
  },
  "inputs": {
    "repository": "/Users/cvences/projects/current",
    "branch": "main"
  },
  "outputs": {
    "report": "results/daily-reports/",
    "notify": "email"
  }
}
```

## Advanced Patterns

### 1. Context Templates
Store conversation contexts for specific domains:

```markdown
# Web Development Context

You are a senior web developer with expertise in:
- React, TypeScript, Next.js
- Performance optimization
- Accessibility (WCAG 2.1)
- SEO best practices

Project conventions:
- Use functional components
- Implement custom hooks for logic
- Follow atomic design principles
- Write tests for all components

Current project stack:
- Next.js 14
- TypeScript 5
- Tailwind CSS
- Prisma ORM
```

### 2. Validation Rules
Define validation criteria for task outputs:

```yaml
validations:
  code_quality:
    - "No console.log statements"
    - "All functions have JSDoc comments"
    - "Test coverage > 80%"
    - "No TODO comments in production code"

  security:
    - "No hardcoded credentials"
    - "Input validation on all endpoints"
    - "SQL injection prevention"
    - "XSS protection enabled"
```

### 3. Task Dependencies
Define relationships between tasks:

```json
{
  "task": "deploy-application",
  "dependencies": [
    {
      "task": "run-tests",
      "status": "passed"
    },
    {
      "task": "security-scan",
      "status": "passed"
    },
    {
      "task": "build-production",
      "status": "completed"
    }
  ]
}
```

## Integration with Other Directories

### Link to Visuals
Reference diagrams and screenshots:
```markdown
See architecture diagram: ../../visuals/diagrams/system-architecture.png
UI mockup: ../../visuals/wireframes/feature-x.png
```

### Use with Projects
Apply tasks to specific projects:
```markdown
Project: ../../projects/planning/e-commerce-app.md
Task: Generate API endpoints based on project requirements
```

### Connect to Knowledge Base
Reference documentation:
```markdown
Best practices: ../../knowledge/research/react-patterns.md
Code snippets: ../../knowledge/snippets/javascript/
```

## Best Practices

1. **Naming Convention:**
   - Use descriptive names: `generate-rest-api.yaml`
   - Include version: `code-review-v2.md`
   - Categorize by type: `frontend-`, `backend-`, `devops-`

2. **Documentation:**
   - Include usage examples in each task
   - Document required inputs and outputs
   - Specify tool requirements

3. **Version Control:**
   - Track changes to task definitions
   - Tag stable versions
   - Keep changelog for complex chains

4. **Testing:**
   - Test tasks in isolation first
   - Validate outputs against criteria
   - Keep test results for reference