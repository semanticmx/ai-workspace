# 📅 Daily Development Workflow

Your day-to-day AI-assisted development workflow.

## Morning Routine

### Start Your Day
```bash
# Check your TODOs
claude-code "Show me today's tasks and priorities"

# Review yesterday's work
claude-code "Summarize what I worked on yesterday from completed TODOs"

# Plan the day
claude-code "Create a plan for today based on active TODOs"
```

### Quick Commands
```bash
# Shortcut aliases (add to ~/.zshrc)
alias morning="claude-code 'Start my development day: show TODOs, check project status'"
alias standup="claude-code 'Generate standup report from yesterday completed and today planned'"
alias focus="claude-code 'Pick the most important task and help me start'"
```

## During Development

### Feature Implementation
```bash
# Start new feature
claude-code "I need to implement [feature]. Create a plan and TODOs"

# Get implementation help
claude-code "Help me implement [specific part] following our project conventions"

# Review your work
claude-code "Review the changes I just made for best practices"
```

### Debugging Session
```bash
# Describe the bug
claude-code "Help me debug: [describe issue]"

# Analyze error
claude-code "Analyze this error: [paste error]"

# Find similar issues
claude-code "Search codebase for similar patterns that might cause [issue]"
```

### Code Review
```bash
# Before committing
claude-code "Review my staged changes for issues"

# Review specific files
claude-code "Review [file] for security and performance"

# Get improvement suggestions
claude-code "Suggest improvements for [component/function]"
```

## Task Management

### TODO Workflow
```bash
# Add new task
claude-code "Add TODO: [task description] with priority [high/medium/low]"

# Update task status
claude-code "Mark '[task]' as in progress"
claude-code "Mark '[task]' as completed"

# Review TODOs
claude-code "Show all active TODOs sorted by priority"
claude-code "Move completed TODOs to archive"
```

### Context Switching
```bash
# Save current context before switching
claude-code "Save current conversation as [project]-[feature] context"

# Load previous context
claude-code "Load context for [project/feature]"

# Quick context
claude-code "I'm working on [project] with [tech stack], help me with [task]"
```

## Common Development Tasks

### 1. Writing Code
```bash
# Generate code
claude-code "Generate a [component/function] that [does something]"

# Refactor code
claude-code "Refactor [file/function] to improve [performance/readability]"

# Add features
claude-code "Add [feature] to [component] following existing patterns"
```

### 2. Testing
```bash
# Write tests
claude-code "Write tests for [component/function]"

# Fix failing tests
claude-code "Help me fix this failing test: [error]"

# Improve coverage
claude-code "Identify untested code and write missing tests"
```

### 3. Documentation
```bash
# Document code
claude-code "Add documentation to [file/function]"

# Create guides
claude-code "Create a guide for [feature/process]"

# Update README
claude-code "Update README with [new feature/changes]"
```

### 4. Git Workflow
```bash
# Commit message
claude-code "Generate commit message for staged changes"

# Branch strategy
claude-code "Create branch name for [feature]"

# PR description
claude-code "Generate PR description for [feature branch]"
```

## End of Day

### Wrap Up
```bash
# Summarize work
claude-code "Summarize what I accomplished today"

# Update TODOs
claude-code "Update TODO statuses and create tomorrow's plan"

# Save context
claude-code "Save today's work context"

# Clean up
claude-code "Archive completed tasks and organize workspace"
```

### Daily Report
```bash
claude-code "Generate daily report:
- Completed tasks
- Code changes
- Issues encountered
- Tomorrow's priorities"
```

## Productivity Tips

### Time Blocking
```bash
# Morning: Planning & Priority Tasks
9:00-9:30   - Review TODOs, plan day
9:30-12:00  - Focus on highest priority task

# Afternoon: Implementation & Collaboration
13:00-15:00 - Feature development
15:00-16:00 - Code reviews, debugging

# End of Day: Wrap-up
16:00-17:00 - Documentation, cleanup, planning
```

### Focus Sessions
```bash
# Deep work session
claude-code "Start focus session:
1. Pick one task from TODOs
2. Break it into steps
3. Set 2-hour timer
4. Help me implement without distractions"

# Pomodoro technique
claude-code "Start pomodoro:
- 25 min: Work on [task]
- 5 min: Break
- Repeat 4x
- 15 min: Long break"
```

### Quick Wins
```bash
# Find easy fixes
claude-code "Find quick wins:
- Simple bugs to fix
- Easy refactors
- Documentation updates
- Test improvements"
```

## Templates

### Daily Standup
```markdown
# Daily Standup - [Date]

## Yesterday
- ✅ Completed [task]
- 🔄 Worked on [ongoing task]
- 🐛 Fixed [bug]

## Today
- 🎯 Priority: [main task]
- 📝 Also: [other tasks]

## Blockers
- ⚠️ [Any blockers]
```

### Task Template
```markdown
# Task: [Name]

## Description
[What needs to be done]

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

## Steps
1. [ ] Step 1
2. [ ] Step 2

## Notes
[Any relevant context]
```

## Keyboard Shortcuts

Add to your shell config (`~/.zshrc`):

```bash
# AI Workspace shortcuts
alias ai="claude-code"
alias aitodo="ai 'Show active TODOs'"
alias aiplan="ai 'Plan my day'"
alias aicommit="ai 'Generate commit message'"
alias aireview="ai 'Review staged changes'"
alias aidebug="ai 'Help debug:'"
alias aidone="ai 'Mark last TODO as complete'"
alias aisave="ai 'Save this context'"
alias aihelp="ai 'Show AI workspace commands'"
```

## Integration with IDE

### VSCode Tasks
Create `.vscode/tasks.json`:
```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "AI: Review Current File",
      "type": "shell",
      "command": "claude-code 'Review ${file}'",
      "problemMatcher": []
    },
    {
      "label": "AI: Generate Tests",
      "type": "shell",
      "command": "claude-code 'Generate tests for ${file}'",
      "problemMatcher": []
    },
    {
      "label": "AI: Add TODO",
      "type": "shell",
      "command": "claude-code 'Add TODO: ${input:todoDescription}'",
      "problemMatcher": []
    }
  ],
  "inputs": [
    {
      "id": "todoDescription",
      "type": "promptString",
      "description": "TODO description"
    }
  ]
}
```

## Troubleshooting Daily Issues

| Issue | Quick Fix |
|-------|-----------|
| Lost context | `claude-code "Load last saved context"` |
| Too many TODOs | `claude-code "Prioritize TODOs by importance"` |
| Stuck on problem | `claude-code "Break down [problem] into smaller steps"` |
| Need inspiration | `claude-code "Suggest improvements for [project]"` |
| Repetitive task | `claude-code "Create automation for [task]"` |

---

**Pro Tip**: Create a personal command guide in `guides/personal/my-commands.md` with your most-used Claude commands!