#!/bin/bash

# AI Workspace - Project Planning & Management System
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

# Help function
show_help() {
    cat << EOF
AI Workspace Planning System

Usage: ai-plan <command> <project-name> [options]

Commands:
  new <name>              Create new project planning structure
  generate <name>        Generate project plan from requirements
  architecture <name>     Design project architecture
  deploy <name>          Deploy project to GitHub
  activate <name>        Set project as active
  status <name>          Show project status
  sync <name>            Sync planning with deployed code

Options:
  --github-account      GitHub account name
  --type               Project type (web, api, cli, ml)
  --template           Use specific template

Examples:
  ai-plan new my-app --type web
  ai-plan architecture my-app
  ai-plan deploy my-app --github-account myusername

EOF
}

# Create new project planning
new_project() {
    local PROJECT_NAME=$1
    shift

    # Parse options
    local PROJECT_TYPE="web"
    for arg in "$@"; do
        if [[ "$arg" == "--type="* ]]; then
            PROJECT_TYPE="${arg#--type=}"
        elif [[ "$arg" == "--type" ]]; then
            # Handle --type followed by value
            shift
            PROJECT_TYPE="$1"
        fi
    done

    echo -e "${BLUE}📋 Creating new project planning: $PROJECT_NAME${NC}"

    # Create project structure
    PROJECT_DIR="$WORKSPACE/projects/$PROJECT_NAME"
    mkdir -p "$PROJECT_DIR"/{planning,claude,deploy}

    # Create planning documents with TBD content
    cat > "$PROJECT_DIR/planning/requirements.md" << EOF
TBD
EOF

    # Create architecture template
    cat > "$PROJECT_DIR/planning/architecture.md" << EOF
# Architecture: $PROJECT_NAME

## System Overview
[High-level architecture description]

## Components
### Frontend
- Framework: [Define]
- State Management: [Define]

### Backend
- Framework: [Define]
- Database: [Define]

### Infrastructure
- Hosting: [Define]
- CI/CD: [Define]

## Data Flow
[Describe how data flows through the system]

## API Design
[Define API structure]

## Security Architecture
[Security measures and patterns]

## Deployment Architecture
[How the system will be deployed]

---
Status: Draft
EOF

    # Create project-specific CLAUDE.md
    cat > "$PROJECT_DIR/claude/CLAUDE.md" << EOF
# Claude Configuration: $PROJECT_NAME

> Project-specific instructions that override global rules

## Project Context
- **Type**: $PROJECT_TYPE
- **Status**: Planning
- **Created**: $(date '+%Y-%m-%d')

## Project-Specific Rules
[Add any project-specific rules here]

## Tech Stack Overrides
[Override global tech stack if needed]

## Development Patterns
[Project-specific patterns to follow]

## Excluded Directories
[Directories Claude should ignore]

## Custom Commands
[Project-specific Claude commands]

---
*Inherits from: global/CLAUDE-GLOBAL.md*
EOF

    # Create MCP configuration
    cat > "$PROJECT_DIR/claude/mcp.json" << EOF
{
  "description": "MCP servers for $PROJECT_NAME",
  "extends": "../../global/mcp/default.json",
  "mcpServers": {
    "project-files": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem"],
      "env": {
        "ALLOWED_DIRECTORIES": "$PROJECT_DIR,\${GITHUB_DIR:-$HOME/GitHub}/$PROJECT_NAME"
      }
    }
  }
}
EOF

    # Create deployment structure
    cat > "$PROJECT_DIR/deploy/structure.yaml" << EOF
name: $PROJECT_NAME
type: $PROJECT_TYPE
github:
  account: \${GITHUB_ACCOUNT}
  repo: $PROJECT_NAME

structure:
  - src/
  - tests/
  - docs/
  - .github/workflows/
  - .claude/

files:
  - path: README.md
    template: readme
  - path: .gitignore
    template: gitignore-$PROJECT_TYPE
  - path: CLAUDE.md
    source: ../claude/CLAUDE.md
  - path: .claude/project.json
    source: ../claude/mcp.json

initialization:
  - git init
  - git add .
  - git commit -m "Initial project structure"
EOF

    # Create project link
    echo "$PROJECT_DIR" > "$PROJECT_DIR/.project-link"

    echo -e "${GREEN}✅ Project planning created at: $PROJECT_DIR${NC}"
    echo -e "${YELLOW}Next step: ai-plan generate $PROJECT_NAME${NC}"
}

# Generate project plan from requirements
generate_project() {
    local PROJECT_NAME=$1
    PROJECT_DIR="$WORKSPACE/projects/$PROJECT_NAME"

    if [ ! -d "$PROJECT_DIR" ]; then
        echo -e "${RED}Error: Project $PROJECT_NAME not found${NC}"
        exit 1
    fi

    # Check if requirements.md exists and is not TBD
    if [ ! -f "$PROJECT_DIR/planning/requirements.md" ]; then
        echo -e "${RED}Error: requirements.md not found${NC}"
        exit 1
    fi

    REQUIREMENTS_CONTENT=$(cat "$PROJECT_DIR/planning/requirements.md")
    if [ "$REQUIREMENTS_CONTENT" = "TBD" ]; then
        echo -e "${RED}Error: Please update requirements.md with actual requirements before generating${NC}"
        exit 1
    fi

    echo -e "${BLUE}🚀 Generating project plan for: $PROJECT_NAME${NC}"

    # Determine project type (read from architecture.md or default to generic)
    PROJECT_TYPE="generic"
    if [ -f "$PROJECT_DIR/planning/architecture.md" ]; then
        TYPE_LINE=$(grep "Type:" "$PROJECT_DIR/planning/architecture.md" 2>/dev/null || echo "")
        if [ ! -z "$TYPE_LINE" ]; then
            PROJECT_TYPE=$(echo "$TYPE_LINE" | cut -d: -f2 | tr -d ' ')
        fi
    fi

    # Check for command line override
    for arg in "$@"; do
        if [[ "$arg" == "--type="* ]]; then
            PROJECT_TYPE="${arg#--type=}"
        fi
    done

    # Select appropriate template
    TEMPLATE_FILE="$WORKSPACE/system/prompts/generate-plan-$PROJECT_TYPE.md"
    if [ ! -f "$TEMPLATE_FILE" ]; then
        echo -e "${YELLOW}Warning: Template for type '$PROJECT_TYPE' not found, using generic${NC}"
        TEMPLATE_FILE="$WORKSPACE/system/prompts/generate-plan-generic.md"
    fi

    # Update architecture.md with project type
    echo -e "${BLUE}Generating architecture document...${NC}"
    cat > "$PROJECT_DIR/planning/architecture.md" << EOF
# Architecture: $PROJECT_NAME

Type: $PROJECT_TYPE
Status: Generated
Generated: $(date '+%Y-%m-%d')

## Overview
[Generated from requirements - To be filled by AI]

## System Components
[To be generated based on requirements]

## Technology Stack
[To be generated based on project type: $PROJECT_TYPE]

## Data Flow
[To be generated]

## Security Architecture
[To be generated]

## Deployment Strategy
[To be generated]

---
Note: Run 'ai-plan architecture $PROJECT_NAME' to complete the generation with AI assistance
EOF

    # Generate user-stories.md
    echo -e "${BLUE}Generating user stories...${NC}"
    cat > "$PROJECT_DIR/planning/user-stories.md" << EOF
# User Stories: $PROJECT_NAME

Generated: $(date '+%Y-%m-%d')
Type: $PROJECT_TYPE

## Epic: Core Functionality

### Must Have
- [ ] US-001: As a user, I want [feature from requirements] so that [benefit]
- [ ] US-002: As a user, I want [feature from requirements] so that [benefit]

### Should Have
- [ ] US-003: As a user, I want [feature from requirements] so that [benefit]

### Nice to Have
- [ ] US-004: As a user, I want [feature from requirements] so that [benefit]

## Acceptance Criteria
[To be generated from requirements]

---
Note: Update these stories based on the requirements in requirements.md
EOF

    # Create tasks directory
    mkdir -p "$PROJECT_DIR/planning/tasks"

    # Generate sample task breakdown
    echo -e "${BLUE}Generating task breakdowns...${NC}"
    cat > "$PROJECT_DIR/planning/tasks/us-001-task-breakdown.md" << EOF
# Task Breakdown: US-001

User Story: [Reference to user story]
Estimated Effort: [S/M/L/XL]

## Tasks

### 1. Setup and Configuration
- [ ] Initialize project structure
- [ ] Configure development environment
- [ ] Setup testing framework
Estimate: 4 hours

### 2. Core Implementation
- [ ] Implement main functionality
- [ ] Add error handling
- [ ] Create unit tests
Estimate: 8 hours

### 3. Integration
- [ ] Integrate with existing components
- [ ] Add integration tests
- [ ] Update documentation
Estimate: 4 hours

## Dependencies
- Requires: [Prerequisites]
- Blocks: [Dependent tasks]

## Technical Notes
[Implementation details to be added]

---
Generated: $(date '+%Y-%m-%d')
EOF

    # Launch AI to complete the generation
    echo -e "${GREEN}✅ Project structure generated${NC}"
    echo -e "${YELLOW}Launching AI to complete the planning based on requirements...${NC}"

    # Use Claude to complete the generation
    claude "Please help complete the project planning for $PROJECT_NAME:
1. Read the requirements at: $PROJECT_DIR/planning/requirements.md
2. Read the planning template at: $TEMPLATE_FILE
3. Update the following files with detailed content:
   - $PROJECT_DIR/planning/architecture.md
   - $PROJECT_DIR/planning/user-stories.md
   - Create detailed task breakdowns in $PROJECT_DIR/planning/tasks/

Use the template instructions to generate comprehensive planning documents based on the requirements."
}

# Design architecture
design_architecture() {
    local PROJECT_NAME=$1
    PROJECT_DIR="$WORKSPACE/projects/$PROJECT_NAME"

    if [ ! -d "$PROJECT_DIR" ]; then
        echo -e "${RED}Error: Project $PROJECT_NAME not found${NC}"
        exit 1
    fi

    echo -e "${BLUE}🏗️ Opening architecture design for: $PROJECT_NAME${NC}"
    echo -e "${YELLOW}Edit: $PROJECT_DIR/planning/architecture.md${NC}"

    # Launch Claude to help with architecture
    claude "Help me design the architecture for $PROJECT_NAME. Read the requirements at $PROJECT_DIR/planning/requirements.md and update the architecture document."
}

# Deploy project
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
    echo -e "${GREEN}✅ Bidirectional links created${NC}"
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
    echo -e "${YELLOW}Planning:${NC} $PROJECT_DIR"

    if [ -f "$PROJECT_DIR/.deploy-link" ]; then
        DEPLOY_DIR=$(cat "$PROJECT_DIR/.deploy-link")
        echo -e "${YELLOW}Deployed:${NC} $DEPLOY_DIR"
    else
        echo -e "${YELLOW}Deployed:${NC} Not deployed yet"
    fi

    # Check for active status
    if [ -L "$WORKSPACE/active-projects/current" ]; then
        ACTIVE=$(readlink "$WORKSPACE/active-projects/current")
        if [ "$ACTIVE" = "$PROJECT_DIR" ]; then
            echo -e "${GREEN}Status: ACTIVE${NC}"
        fi
    fi
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
        new_project "$PROJECT" "$@"
        ;;
    generate)
        generate_project "$PROJECT" "$@"
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
    help|--help|-h)
        show_help
        ;;
    *)
        echo -e "${RED}Unknown command: $COMMAND${NC}"
        show_help
        exit 1
        ;;
esac