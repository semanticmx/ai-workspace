#!/bin/bash

# Task Executor Script
# Automates the execution of user story tasks using Claude

set -e

# Configuration
WORKSPACE="${AI_WORKSPACE:-$HOME/ai-workspace}"
PROJECT_NAME=$1
USER_STORY=$2

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Help function
show_help() {
    cat << EOF
Task Executor - Automated Task Implementation with TDD

Usage: execute-tasks <project-name> <user-story-id>

Arguments:
  project-name    Name of the project in ai-workspace
  user-story-id   User story identifier (e.g., us-001)

Examples:
  execute-tasks my-app us-001
  execute-tasks todo-cli us-002

This script will:
1. Verify you're on a feature branch
2. Implement tasks using TDD approach
3. Create TODOs for manual tasks
4. Update task status documentation

Prerequisites:
- Project exists in $WORKSPACE/projects/
- Task breakdown file exists: planning/tasks/<user-story>-task-breakdown.md
- Git repository initialized
- Test framework configured

EOF
}

# Validate arguments
if [ -z "$PROJECT_NAME" ] || [ -z "$USER_STORY" ]; then
    echo -e "${RED}Error: Missing required arguments${NC}"
    show_help
    exit 1
fi

# Check if project exists
PROJECT_DIR="$WORKSPACE/projects/$PROJECT_NAME"
if [ ! -d "$PROJECT_DIR" ]; then
    echo -e "${RED}Error: Project '$PROJECT_NAME' not found${NC}"
    echo "Expected location: $PROJECT_DIR"
    exit 1
fi

# Check if task breakdown exists
TASK_FILE="$PROJECT_DIR/planning/tasks/${USER_STORY}-task-breakdown.md"
if [ ! -f "$TASK_FILE" ]; then
    echo -e "${RED}Error: Task breakdown not found${NC}"
    echo "Expected file: $TASK_FILE"
    echo -e "${YELLOW}Available task files:${NC}"
    ls -la "$PROJECT_DIR/planning/tasks/" 2>/dev/null || echo "No task files found"
    exit 1
fi

# Check if in a git repository
if [ -f "$PROJECT_DIR/.deploy-link" ]; then
    DEPLOY_DIR=$(cat "$PROJECT_DIR/.deploy-link")
    if [ -d "$DEPLOY_DIR" ]; then
        cd "$DEPLOY_DIR"
    else
        echo -e "${RED}Error: Deployed directory not found${NC}"
        echo "Expected: $DEPLOY_DIR"
        exit 1
    fi
else
    echo -e "${YELLOW}Warning: Project not deployed. Working in planning directory.${NC}"
    cd "$PROJECT_DIR"
fi

# Check git status
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}Error: Not a git repository${NC}"
    echo "Initialize git first: git init"
    exit 1
fi

# Check current branch
CURRENT_BRANCH=$(git branch --show-current)
echo -e "${BLUE}Current branch: $CURRENT_BRANCH${NC}"

# Verify not on protected branch
PROTECTED_BRANCHES=("main" "master" "develop" "production")
for PROTECTED in "${PROTECTED_BRANCHES[@]}"; do
    if [ "$CURRENT_BRANCH" = "$PROTECTED" ]; then
        echo -e "${RED}Error: Cannot execute tasks on protected branch '$PROTECTED'${NC}"
        echo -e "${YELLOW}Create a feature branch:${NC}"
        echo "  git checkout -b feature/${USER_STORY}-implementation"
        exit 1
    fi
done

# Create todos directory structure
TODO_DIR="$WORKSPACE/todos/active/$PROJECT_NAME"
mkdir -p "$TODO_DIR"

# Prepare context for Claude
echo -e "${BLUE}🚀 Starting task execution for $USER_STORY${NC}"
echo -e "${YELLOW}Project: $PROJECT_NAME${NC}"
echo -e "${YELLOW}Task file: $TASK_FILE${NC}"
echo -e "${YELLOW}Working directory: $(pwd)${NC}"

# Generate execution prompt
PROMPT="Execute the tasks from the user story breakdown following the task executor prompt.

Project: $PROJECT_NAME
User Story: $USER_STORY
Task File: $TASK_FILE
TODO Directory: $TODO_DIR
Current Branch: $CURRENT_BRANCH
Working Directory: $(pwd)

Instructions:
1. Read the task executor prompt at: $WORKSPACE/system/prompts/task-executor.md
2. Read the task breakdown at: $TASK_FILE
3. Implement each task following TDD methodology
4. Create TODOs for manual tasks in: $TODO_DIR
5. Update the task breakdown status after completion
6. Provide a summary of completed and pending tasks

Remember:
- Write failing tests first (RED)
- Implement minimal code to pass (GREEN)
- Refactor if needed (REFACTOR)
- Commit after each task
- Run pre-commit checks before final commit
- Create detailed TODOs for manual tasks"

# Execute with Claude
echo -e "${GREEN}✅ Launching Claude to execute tasks...${NC}"
claude "$PROMPT"

# Post-execution summary
echo -e "${GREEN}✅ Task execution initiated${NC}"
echo -e "${BLUE}Next steps:${NC}"
echo "1. Review the implementation"
echo "2. Check TODOs in: $TODO_DIR"
echo "3. Run tests: npm test (or appropriate command)"
echo "4. Create PR when ready"

# Show git status
echo -e "${BLUE}📊 Git Status:${NC}"
git status --short

# Show TODO files if created
if [ -d "$TODO_DIR" ] && [ "$(ls -A $TODO_DIR)" ]; then
    echo -e "${YELLOW}📝 Created TODOs:${NC}"
    ls -la "$TODO_DIR"
fi