# Agents Directory

Store AI agent configurations, contexts, and custom rules.

## Structure

- **contexts/** - Saved conversation contexts and session data
- **rules/** - Custom instructions and rules for AI behavior
- **personas/** - Different agent personas for various use cases

## Use Cases

### Contexts
Save important AI conversations or contexts for future reference:
- Complex problem-solving sessions
- Project-specific contexts
- Domain knowledge discussions

### Rules
Define custom rules for AI interactions:
- Coding standards and conventions
- Writing style guides
- Domain-specific instructions

### Personas
Configure different AI personas:
- Technical expert
- Creative writer
- Project manager
- Code reviewer

## Example Files

### Context File (contexts/project-setup.md)
```markdown
# Project Setup Context
Date: 2024-01-17
Agent: Claude

## Context
Working on setting up a new React application with TypeScript...

## Key Decisions
- Using Vite for bundling
- Implementing Redux for state management
```

### Rules File (rules/coding-standards.md)
```markdown
# Coding Standards

## General Rules
- Use TypeScript for all new code
- Follow ESLint configuration
- Write tests for all functions

## Naming Conventions
- camelCase for variables
- PascalCase for components
```

### Persona File (personas/code-reviewer.md)
```markdown
# Code Reviewer Persona

## Role
Senior software engineer focused on code quality

## Focus Areas
- Security vulnerabilities
- Performance optimization
- Code maintainability
- Best practices
```