# 📝 TODOs Directory

This directory contains TODO items that require manual intervention and cannot be automated by AI assistants.

## Directory Structure

```
todos/
├── active/           # Current TODOs requiring action
│   └── [project]/   # TODOs grouped by project
├── completed/       # Completed TODOs (for reference)
│   └── [project]/
└── blocked/         # TODOs waiting on external dependencies
    └── [project]/
```

## TODO Categories

### Active TODOs
Tasks that need immediate or near-term attention:
- AWS/Azure console configurations
- API key generation
- DNS updates
- SSL certificate installation
- Third-party service setup
- Manual approval processes

### Completed TODOs
Archived for reference and audit trail:
- Successfully completed manual tasks
- Include completion date and who completed it
- Keep for knowledge sharing

### Blocked TODOs
Tasks waiting on:
- External approvals
- Vendor responses
- Access permissions
- Budget approval
- Technical dependencies

## TODO File Format

Each TODO should follow this structure:

```markdown
# TODO: [Brief Description]

User Story: US-XXX
Priority: High/Medium/Low
Created: YYYY-MM-DD
Assigned: [Name]
Status: Active/Blocked/Completed

## Objective
[What needs to be accomplished]

## Prerequisites
- [ ] Required access/permissions
- [ ] Required tools/accounts
- [ ] Dependencies

## Step-by-Step Instructions
1. [Detailed step 1]
2. [Detailed step 2]
...

## Verification
- [ ] How to verify completion
- [ ] Expected outcome

## Notes
[Additional context, links, etc.]
```

## Workflow

1. **Creation**: TODOs are automatically created by `execute-tasks` command
2. **Assignment**: Team member claims TODO and updates "Assigned" field
3. **Execution**: Follow step-by-step instructions
4. **Verification**: Complete verification checklist
5. **Completion**: Move to `completed/` directory with completion notes

## Best Practices

1. **Be Specific**: Include exact URLs, button names, field values
2. **Add Screenshots**: When UI steps are involved
3. **Include Rollback**: How to undo if something goes wrong
4. **Link Resources**: Documentation, tutorials, support articles
5. **Update Status**: Keep status current for team visibility

## Moving TODOs

```bash
# Mark as completed
mv todos/active/my-project/todo-001.md todos/completed/my-project/

# Mark as blocked
mv todos/active/my-project/todo-002.md todos/blocked/my-project/

# Reactivate blocked TODO
mv todos/blocked/my-project/todo-002.md todos/active/my-project/
```

## Tracking

Create a summary file for each project:

```bash
# todos/active/my-project/README.md
# Active TODOs for My Project

## High Priority
1. TODO-001: Configure AWS Lambda - John (Due: 2024-01-20)

## Medium Priority
2. TODO-002: Setup monitoring - Unassigned

## Low Priority
3. TODO-003: Update documentation - Jane
```

## Integration with Task Execution

The `execute-tasks` script automatically:
1. Creates TODOs for manual tasks
2. Provides detailed instructions
3. Links to relevant documentation
4. Includes verification steps

## Automation Boundaries

TODOs are created for tasks that require:
- Web console access (AWS, Azure, GCP)
- Manual approval workflows
- Physical hardware configuration
- Payment or billing setup
- Legal or compliance reviews
- Third-party account creation
- Security certificate handling
- Production environment access

---

For more information, see:
- [Task Execution Guide](../guides/workflows/task-execution.md)
- [Execute Tasks Script](../system/scripts/execute-tasks.sh)
