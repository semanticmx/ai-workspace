#!/bin/bash

# AI Workspace - Project Planning & Management System v2
# Usage: ai-plan <command> <project-name> [options]

set -e

# Configuration
WORKSPACE="${AI_WORKSPACE:-$HOME/ai-workspace}"
COMMAND=$1
PROJECT=$2
shift 2 2>/dev/null || true

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Parse options
TYPE=""
GITHUB_ACCOUNT=""
while [[ $# -gt 0 ]]; do
    case $1 in
        --type)
            TYPE="$2"
            shift 2
            ;;
        --github-account)
            GITHUB_ACCOUNT="$2"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

# Help function
show_help() {
    cat << EOF
AI Workspace Planning System v2

Usage: ai-plan <command> <project-name> [options]

Commands:
  new <name>              Create minimal project structure with TBD requirements
  generate <name>         Generate complete plan from requirements using AI
  architecture <name>     Review/edit project architecture
  deploy <name>          Deploy project to GitHub
  activate <name>        Set project as active
  status <name>          Show project status
  sync <name>            Sync planning with deployed code

Options:
  --github-account      GitHub account name
  --type               Project type (web, api, cli, ml)

Workflow:
  1. ai-plan new my-app --type web      # Creates minimal structure
  2. Edit requirements.md                # Add your requirements
  3. ai-plan generate my-app             # AI generates complete plan
  4. ai-plan deploy my-app               # Deploy to GitHub

Examples:
  ai-plan new my-app --type cli
  ai-plan generate my-app
  ai-plan deploy my-app --github-account myusername

EOF
}

# Create new project with minimal structure
new_project() {
    local PROJECT_NAME=$1
    local PROJECT_TYPE=${TYPE:-web}

    echo -e "${BLUE}📋 Creating new project structure: $PROJECT_NAME${NC}"

    # Create project structure
    PROJECT_DIR="$WORKSPACE/projects/$PROJECT_NAME"
    mkdir -p "$PROJECT_DIR"/{planning/tasks,claude,deploy}

    # Create minimal requirements file
    cat > "$PROJECT_DIR/planning/requirements.md" << EOF
# Requirements: $PROJECT_NAME

## Project Overview
TBD - Describe what this project should do

## Core Features
TBD - List the main features needed

## Target Users
TBD - Who will use this?

## Success Criteria
TBD - How will we know it's successful?

---
Created: $(date '+%Y-%m-%d')
Type: $PROJECT_TYPE
Status: Requirements Needed
EOF

    # Create minimal CLAUDE.md
    cat > "$PROJECT_DIR/claude/CLAUDE.md" << EOF
# Claude Configuration: $PROJECT_NAME

## Project Context
- **Type**: $PROJECT_TYPE
- **Status**: Requirements Phase
- **Created**: $(date '+%Y-%m-%d')

## Project-Specific Rules
TBD - Will be generated after requirements are defined

---
*Inherits from: global/CLAUDE-GLOBAL.md*
EOF

    # Create minimal MCP configuration
    cat > "$PROJECT_DIR/claude/mcp.json" << EOF
{
  "description": "MCP servers for $PROJECT_NAME",
  "extends": "../../global/mcp/default.json",
  "mcpServers": {
    "project-files": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem"],
      "env": {
        "ALLOWED_DIRECTORIES": "$PROJECT_DIR"
      }
    }
  }
}
EOF

    # Store project type for generation
    echo "$PROJECT_TYPE" > "$PROJECT_DIR/.project-type"

    echo -e "${GREEN}✅ Project structure created at: $PROJECT_DIR${NC}"
    echo -e "${YELLOW}Next steps:${NC}"
    echo -e "  1. Edit: $PROJECT_DIR/planning/requirements.md"
    echo -e "  2. Run: ai-plan generate $PROJECT_NAME"
}

# Generate complete plan from requirements
generate_project() {
    local PROJECT_NAME=$1
    PROJECT_DIR="$WORKSPACE/projects/$PROJECT_NAME"

    if [ ! -d "$PROJECT_DIR" ]; then
        echo -e "${RED}Error: Project $PROJECT_NAME not found${NC}"
        echo "Run 'ai-plan new $PROJECT_NAME' first"
        exit 1
    fi

    # Get project type
    if [ -f "$PROJECT_DIR/.project-type" ]; then
        PROJECT_TYPE=$(cat "$PROJECT_DIR/.project-type")
    else
        PROJECT_TYPE="web"
    fi

    # Check if prompt template exists
    PROMPT_FILE="$WORKSPACE/system/prompts/generate-plan-$PROJECT_TYPE.md"
    if [ ! -f "$PROMPT_FILE" ]; then
        echo -e "${YELLOW}Warning: No template for type '$PROJECT_TYPE', using generic${NC}"
        PROMPT_FILE="$WORKSPACE/system/prompts/generate-plan-generic.md"
    fi

    echo -e "${BLUE}🤖 Generating project plan for: $PROJECT_NAME ($PROJECT_TYPE)${NC}"
    echo -e "${YELLOW}Using template: $PROMPT_FILE${NC}"

    # Generate the plan using Claude
    cd "$PROJECT_DIR"

    # Create architecture.md
    echo -e "${GREEN}Generating architecture...${NC}"
    claude --model opus "Read the requirements in $PROJECT_DIR/planning/requirements.md and the generation prompt at $PROMPT_FILE. If file architecture.md exists, ask if it's OK to update or complete the task, otherwise, generate a comprehensive architecture.md file and save it to $PROJECT_DIR/planning/architecture.md"

    # Create user-stories.md
    echo -e "${GREEN}Generating user stories...${NC}"
    claude --model opus "Based on the architechture in $PROJECT_DIR/planning/architecture.md, If file $PROJECT_DIR/planning/user-stories.md exists, ask if it's OK to update or complete the user stories, otherwise, create a complete set of detailed, comprehensive, prioritized user stories, ensuring full coverage of every functional and non-functional requirement described in the architecture.md document, with acceptance criteria and define measurable Service Level Indicators (SLI) and corresponding Service Level Objectives (SLO) to quantify performance, reliability, scalability, or other quality attributes. Prioritize user stories based on business value, user impact, and technical dependencies, producing a single ordered backlog list ready for integration into a project management tool following DSDM MoSCoW prioritization. Save to $PROJECT_DIR/planning/user-stories.md"

    # Create task breakdowns
    echo -e "${GREEN}Generating task breakdowns...${NC}"
    claude --model opus "Based on the user stories in $PROJECT_DIR/planning/user-stories.md, for each user story missing in $PROJECT_DIR/planning/tasks/ create task breakdown files. Each user story should have its own file named us-XXX-story-name.md. Break a single User Story into a sequence of minimal, independently shippable tasks that an AI coding assistant can implement in parallel without breaking changes. Produce a dependency-light task plan that enables independent implementation, testing, rollback, and deployment for UI, backend, and integration slices. Each task must include a developer-ready prompt, clear acceptance criteria, and explicit testability. MANDATORY GUIDELINES: Incremental and logical separation, Keep dependencies minimal; prefer additive, backward compatible changes. Tasks must propose a loose TDD flow: write only failing unit tests for the happy path, additional tests will be added later for each failure during E2E testing. Include tasks to setup the project including a default response, pre-commit for linters, security and testing and github actions for PR testing and Merge artifact building (generating binary releases). Every task must include an explicit rollback_plan and declare blast_radius. Use Conventional Commits after completing each task. For breaking changes, include “BREAKING CHANGE:” and a migration note; otherwise set to none. QUALITY BARS: No cross-task coupling that prevents shipping any single task on its own, No hidden prerequisites; all dependencies listed explicitly."

    # Update CLAUDE.md with project-specific rules
    echo -e "${GREEN}Updating Claude configuration...${NC}"
    claude --model opus "Based on the architecture and requirements, update $PROJECT_DIR/claude/CLAUDE.md with project-specific rules, patterns, and guidelines."

    echo -e "${GREEN}✅ Project plan generated successfully!${NC}"
    echo -e "${YELLOW}Review the generated files:${NC}"
    echo "  - Architecture: $PROJECT_DIR/planning/architecture.md"
    echo "  - User Stories: $PROJECT_DIR/planning/user-stories.md"
    echo "  - Tasks: $PROJECT_DIR/planning/tasks/"
    echo "  - Claude Config: $PROJECT_DIR/claude/CLAUDE.md"
}

# Design/review architecture
design_architecture() {
    local PROJECT_NAME=$1
    PROJECT_DIR="$WORKSPACE/projects/$PROJECT_NAME"

    if [ ! -d "$PROJECT_DIR" ]; then
        echo -e "${RED}Error: Project $PROJECT_NAME not found${NC}"
        exit 1
    fi

    echo -e "${BLUE}🏗️ Opening architecture for: $PROJECT_NAME${NC}"

    if [ ! -f "$PROJECT_DIR/planning/architecture.md" ]; then
        echo -e "${YELLOW}Architecture not generated yet. Run 'ai-plan generate $PROJECT_NAME' first${NC}"
        exit 1
    fi

    echo -e "${YELLOW}Files:${NC}"
    echo "  - Requirements: $PROJECT_DIR/planning/requirements.md"
    echo "  - Architecture: $PROJECT_DIR/planning/architecture.md"
    echo "  - User Stories: $PROJECT_DIR/planning/user-stories.md"

    # Open in Claude for review/editing
    claude --model opus "Review and improve the architecture at $PROJECT_DIR/planning/architecture.md based on requirements. Make any necessary updates."
}

# Deploy project (same as before)
deploy_project() {
    local PROJECT_NAME=$1
    local GITHUB_ACCOUNT=${GITHUB_ACCOUNT:-${2:-$(git config --global user.name)}}

    PROJECT_DIR="$WORKSPACE/projects/$PROJECT_NAME"
    GITHUB_DIR="${GITHUB_DIR:-$HOME/GitHub}"
    TARGET_DIR="$GITHUB_DIR/$GITHUB_ACCOUNT/$PROJECT_NAME"

    echo -e "${BLUE}🚀 Deploying project: $PROJECT_NAME${NC}"
    echo -e "${YELLOW}Target: $TARGET_DIR${NC}"

    # Create GitHub directory structure
    mkdir -p "$GITHUB_DIR/$GITHUB_ACCOUNT"

    # Check if target exists
    if [ -d "$TARGET_DIR" ]; then
        echo -e "${YELLOW}Warning: Target directory exists. Backup will be created.${NC}"
        mv "$TARGET_DIR" "$TARGET_DIR.backup.$(date +%s)"
    fi

    # Create project structure
    mkdir -p "$TARGET_DIR"
    cd "$TARGET_DIR"

    # Copy CLAUDE.md
    cp "$PROJECT_DIR/claude/CLAUDE.md" "$TARGET_DIR/CLAUDE.md"

    # Create .claude directory with project link
    mkdir -p "$TARGET_DIR/.claude"
    echo "$PROJECT_DIR" > "$TARGET_DIR/.claude/workspace-link"
    cp "$PROJECT_DIR/claude/mcp.json" "$TARGET_DIR/.claude/project.json"

    # Create basic structure based on type
    mkdir -p src tests docs .github/workflows

    # Create README
    cat > README.md << EOF
# $PROJECT_NAME

> Project initialized from AI Workspace

## Overview
See planning documents in AI Workspace

## Development
This project is linked to AI Workspace planning at:
\`$PROJECT_DIR\`

## Setup
1. Install dependencies
2. Configure environment
3. Run development server

## AI Assistance
This project includes CLAUDE.md for AI-assisted development.

---
Created: $(date '+%Y-%m-%d')
EOF

    # Initialize git
    git init
    git add .
    git commit -m "Initial project structure from AI Workspace"

    # Create bidirectional link
    echo "$TARGET_DIR" > "$PROJECT_DIR/.deploy-link"

    echo -e "${GREEN}✅ Project deployed to: $TARGET_DIR${NC}"
}

# Activate project
activate_project() {
    local PROJECT_NAME=$1
    PROJECT_DIR="$WORKSPACE/projects/$PROJECT_NAME"

    if [ ! -d "$PROJECT_DIR" ]; then
        echo -e "${RED}Error: Project $PROJECT_NAME not found${NC}"
        exit 1
    fi

    # Create symbolic link
    rm -f "$WORKSPACE/active-projects/current"
    ln -s "$PROJECT_DIR" "$WORKSPACE/active-projects/current"

    echo -e "${GREEN}✅ Project $PROJECT_NAME is now active${NC}"
}

# Show project status
show_status() {
    local PROJECT_NAME=$1
    PROJECT_DIR="$WORKSPACE/projects/$PROJECT_NAME"

    if [ ! -d "$PROJECT_DIR" ]; then
        echo -e "${RED}Error: Project $PROJECT_NAME not found${NC}"
        exit 1
    fi

    echo -e "${BLUE}📊 Project Status: $PROJECT_NAME${NC}"

    # Check project type
    if [ -f "$PROJECT_DIR/.project-type" ]; then
        echo -e "${YELLOW}Type:${NC} $(cat $PROJECT_DIR/.project-type)"
    fi

    # Check requirements status
    if grep -q "TBD" "$PROJECT_DIR/planning/requirements.md" 2>/dev/null; then
        echo -e "${YELLOW}Requirements:${NC} ⚠️  Needs completion"
    else
        echo -e "${YELLOW}Requirements:${NC} ✅ Defined"
    fi

    # Check if generated
    if [ -f "$PROJECT_DIR/planning/architecture.md" ] && ! grep -q "TBD" "$PROJECT_DIR/planning/architecture.md" 2>/dev/null; then
        echo -e "${YELLOW}Architecture:${NC} ✅ Generated"
    else
        echo -e "${YELLOW}Architecture:${NC} ⚠️  Not generated"
    fi

    # Check deployment
    if [ -f "$PROJECT_DIR/.deploy-link" ]; then
        DEPLOY_DIR=$(cat "$PROJECT_DIR/.deploy-link")
        echo -e "${YELLOW}Deployed:${NC} ✅ $DEPLOY_DIR"
    else
        echo -e "${YELLOW}Deployed:${NC} ⚠️  Not deployed"
    fi

    echo -e "${YELLOW}Planning:${NC} $PROJECT_DIR"
}

# Sync project
sync_project() {
    local PROJECT_NAME=$1
    PROJECT_DIR="$WORKSPACE/projects/$PROJECT_NAME"

    if [ ! -f "$PROJECT_DIR/.deploy-link" ]; then
        echo -e "${RED}Error: Project not deployed yet${NC}"
        exit 1
    fi

    DEPLOY_DIR=$(cat "$PROJECT_DIR/.deploy-link")

    echo -e "${BLUE}🔄 Syncing project: $PROJECT_NAME${NC}"

    # Sync CLAUDE.md
    cp "$PROJECT_DIR/claude/CLAUDE.md" "$DEPLOY_DIR/CLAUDE.md"
    cp "$PROJECT_DIR/claude/mcp.json" "$DEPLOY_DIR/.claude/project.json"

    echo -e "${GREEN}✅ Project synced${NC}"
}

# Main command handling
case "$COMMAND" in
    new)
        new_project "$PROJECT"
        ;;
    generate)
        generate_project "$PROJECT"
        ;;
    architecture)
        design_architecture "$PROJECT"
        ;;
    deploy)
        deploy_project "$PROJECT" "$@"
        ;;
    activate)
        activate_project "$PROJECT"
        ;;
    status)
        show_status "$PROJECT"
        ;;
    sync)
        sync_project "$PROJECT"
        ;;
    help|--help|-h|"")
        show_help
        ;;
    *)
        echo -e "${RED}Unknown command: $COMMAND${NC}"
        show_help
        exit 1
        ;;
esac