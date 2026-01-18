# Workflows Directory

Automation scripts, templates, and workflow configurations.

## Structure

- **scripts/** - Utility scripts for common tasks
- **templates/** - Reusable document and code templates
- **automation/** - CI/CD configs, automation rules, scheduled tasks

## Contents Guide

### Scripts
Useful scripts for repetitive tasks:
- `backup.sh` - Backup important files
- `setup-project.sh` - Initialize new projects
- `cleanup.py` - Clean temporary files
- `deploy.sh` - Deployment scripts

### Templates
Standardized templates:
- `project-readme-template.md`
- `pull-request-template.md`
- `meeting-notes-template.md`
- `code-review-template.md`

### Automation
Automation configurations:
- GitHub Actions workflows
- Cron job configurations
- Task scheduler scripts
- Webhook handlers

## Example Files

### Script Example (scripts/setup-project.sh)
```bash
#!/bin/bash
# Project Setup Script

PROJECT_NAME=$1

# Create project structure
mkdir -p "$PROJECT_NAME"/{src,tests,docs}

# Initialize git
cd "$PROJECT_NAME"
git init

# Create README
echo "# $PROJECT_NAME" > README.md

# Create .gitignore
echo "node_modules/
.env
*.log" > .gitignore

echo "Project $PROJECT_NAME created successfully!"
```

### Template Example (templates/pr-template.md)
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Tests pass locally
- [ ] New tests added
- [ ] Existing tests updated

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
```

### Automation Example (automation/daily-backup.yml)
```yaml
# GitHub Action for daily backup
name: Daily Backup

on:
  schedule:
    - cron: '0 2 * * *'  # Run at 2 AM daily

jobs:
  backup:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run backup
        run: ./scripts/backup.sh
```

## Best Practices
- Make scripts executable: `chmod +x script.sh`
- Add help text to scripts
- Version control automation configs
- Document script dependencies
- Test scripts in safe environment first