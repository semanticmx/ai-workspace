#!/bin/bash

# AI Workspace - New Project Creator
# Usage: ./new-project.sh "project-name" [type]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
WORKSPACE="${AI_WORKSPACE:-$HOME/ai-workspace}"
PROJECT_NAME=$1
PROJECT_TYPE=${2:-"web"}

# Validate inputs
if [ -z "$PROJECT_NAME" ]; then
    echo -e "${RED}Error: Project name required${NC}"
    echo "Usage: $0 <project-name> [type]"
    echo "Types: web, api, cli, ml, mobile"
    exit 1
fi

echo -e "${BLUE}🚀 Creating new project: ${PROJECT_NAME}${NC}"
echo -e "${YELLOW}Type: ${PROJECT_TYPE}${NC}"

# Create project directories
PROJECT_PATH="$WORKSPACE/projects/$PROJECT_NAME"
mkdir -p "$PROJECT_PATH"

# Create workspace documentation
echo -e "${GREEN}📝 Creating project documentation...${NC}"

# Project idea
cat > "$WORKSPACE/projects/ideas/$PROJECT_NAME.md" << EOF
# Project: $PROJECT_NAME

## Created
$(date '+%Y-%m-%d %H:%M:%S')

## Type
$PROJECT_TYPE

## Description
[Add project description]

## Goals
- [ ] Goal 1
- [ ] Goal 2

## Features
- Feature 1
- Feature 2

## Tech Stack
[Define technology stack]

## Next Steps
- [ ] Create detailed plan
- [ ] Set up development environment
- [ ] Create initial structure
EOF

# Project plan
cat > "$WORKSPACE/projects/planning/$PROJECT_NAME-plan.md" << EOF
# Project Plan: $PROJECT_NAME

## Overview
[Project overview]

## Architecture
[System architecture]

## Development Phases
### Phase 1: Foundation
- [ ] Set up project structure
- [ ] Configure development environment
- [ ] Create base components

### Phase 2: Core Features
- [ ] Implement feature 1
- [ ] Implement feature 2

### Phase 3: Polish
- [ ] Testing
- [ ] Documentation
- [ ] Deployment

## Timeline
- Week 1: Foundation
- Week 2-3: Core Features
- Week 4: Polish and Deploy
EOF

# Create TODO list
echo -e "${GREEN}✅ Creating TODO list...${NC}"
cat > "$WORKSPACE/todos/active/$PROJECT_NAME.md" << EOF
# TODO: $PROJECT_NAME
Created: $(date '+%Y-%m-%d')

## 🔴 High Priority
- [ ] Set up project structure
- [ ] Configure development environment
- [ ] Create README

## 🟡 Medium Priority
- [ ] Set up testing framework
- [ ] Configure linting
- [ ] Create CI/CD pipeline

## 🟢 Low Priority
- [ ] Add documentation
- [ ] Set up monitoring
- [ ] Create contribution guidelines

## Notes
- Project type: $PROJECT_TYPE
- Created: $(date)
EOF

# Create MCP configuration
echo -e "${GREEN}⚙️ Creating MCP configuration...${NC}"
cat > "$WORKSPACE/workflows/mcp-configs/$PROJECT_NAME.json" << EOF
{
  "mcpServers": {
    "project-files": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem"],
      "env": {
        "ALLOWED_DIRECTORIES": "$PROJECT_PATH,$WORKSPACE"
      }
    }
  }
}
EOF

# Create project context
echo -e "${GREEN}🤖 Creating AI context...${NC}"
cat > "$WORKSPACE/agents/contexts/$PROJECT_NAME-context.md" << EOF
# Context: $PROJECT_NAME

## Project Type
$PROJECT_TYPE

## Project Path
$PROJECT_PATH

## Conventions
- Code style: [Define style]
- Git workflow: [Define workflow]
- Testing: [Define approach]

## Key Decisions
- [List architectural decisions]

## Important Files
- README.md - Project documentation
- [List other important files]

## Common Tasks
- Run tests: [command]
- Build: [command]
- Deploy: [command]
EOF

# Initialize project based on type
echo -e "${GREEN}🏗️ Initializing project structure...${NC}"
cd "$PROJECT_PATH"

case $PROJECT_TYPE in
    "web")
        echo "Creating web application structure..."
        mkdir -p src/{components,pages,styles,utils}
        mkdir -p public tests docs

        # Create package.json
        cat > package.json << EOF
{
  "name": "$PROJECT_NAME",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "echo 'Configure dev script'",
    "build": "echo 'Configure build script'",
    "test": "echo 'Configure test script'"
  }
}
EOF
        ;;

    "api")
        echo "Creating API structure..."
        mkdir -p src/{controllers,models,routes,middleware,services}
        mkdir -p tests config docs

        # Create package.json
        cat > package.json << EOF
{
  "name": "$PROJECT_NAME-api",
  "version": "0.1.0",
  "main": "src/index.js",
  "scripts": {
    "start": "node src/index.js",
    "dev": "nodemon src/index.js",
    "test": "jest"
  }
}
EOF
        ;;

    "cli")
        echo "Creating CLI tool structure..."
        mkdir -p src/{commands,utils} tests docs

        # Create package.json
        cat > package.json << EOF
{
  "name": "$PROJECT_NAME-cli",
  "version": "0.1.0",
  "bin": {
    "$PROJECT_NAME": "./src/index.js"
  },
  "scripts": {
    "test": "jest"
  }
}
EOF
        ;;

    "ml")
        echo "Creating ML project structure..."
        mkdir -p {notebooks,src,data,models,experiments}
        mkdir -p src/{preprocessing,training,evaluation}

        # Create requirements.txt
        cat > requirements.txt << EOF
numpy
pandas
scikit-learn
jupyter
matplotlib
seaborn
EOF
        ;;

    "mobile")
        echo "Creating mobile app structure..."
        mkdir -p src/{components,screens,navigation,services,utils}
        mkdir -p assets tests

        # Create package.json
        cat > package.json << EOF
{
  "name": "$PROJECT_NAME-mobile",
  "version": "0.1.0",
  "main": "src/App.js",
  "scripts": {
    "start": "expo start",
    "test": "jest"
  }
}
EOF
        ;;

    *)
        echo "Creating generic project structure..."
        mkdir -p src tests docs config
        ;;
esac

# Create README
echo -e "${GREEN}📄 Creating README...${NC}"
cat > README.md << EOF
# $PROJECT_NAME

> $PROJECT_TYPE project created with AI Workspace

## Overview
[Project description]

## Features
- Feature 1
- Feature 2

## Getting Started

### Prerequisites
- [List prerequisites]

### Installation
\`\`\`bash
# Clone the repository
git clone [repository-url]

# Install dependencies
[installation commands]
\`\`\`

### Development
\`\`\`bash
# Start development server
[dev command]

# Run tests
[test command]

# Build for production
[build command]
\`\`\`

## Project Structure
\`\`\`
$PROJECT_NAME/
├── src/           # Source code
├── tests/         # Test files
├── docs/          # Documentation
└── README.md      # This file
\`\`\`

## Contributing
[Contributing guidelines]

## License
[License information]

---

Created with AI Workspace on $(date '+%Y-%m-%d')
EOF

# Initialize git repository
echo -e "${GREEN}🔗 Initializing Git repository...${NC}"
git init
cat > .gitignore << EOF
# Dependencies
node_modules/
venv/
__pycache__/

# Environment
.env
.env.local

# Build
dist/
build/
*.pyc

# IDE
.vscode/
.idea/
*.swp

# OS
.DS_Store
Thumbs.db

# Logs
*.log
logs/
EOF

git add .
git commit -m "Initial commit: $PROJECT_NAME ($PROJECT_TYPE project)"

# Create initial Claude task
echo -e "${GREEN}🤖 Creating Claude task chain...${NC}"
cat > "$WORKSPACE/agents/claude-tasks/chains/$PROJECT_NAME.yaml" << EOF
name: "$PROJECT_NAME Development"
description: "Automated tasks for $PROJECT_NAME"

tasks:
  - name: "Code Review"
    trigger: "pre-commit"
    prompt: "Review staged changes for best practices and issues"

  - name: "Generate Tests"
    trigger: "on-demand"
    prompt: "Generate tests for new code"

  - name: "Update Documentation"
    trigger: "on-demand"
    prompt: "Update documentation based on code changes"

  - name: "Security Check"
    trigger: "pre-deploy"
    prompt: "Check for security vulnerabilities"
EOF

# Final summary
echo -e "${GREEN}✨ Project created successfully!${NC}"
echo
echo -e "${BLUE}📁 Project Structure:${NC}"
echo "   Project: $PROJECT_PATH"
echo "   TODOs: $WORKSPACE/todos/active/$PROJECT_NAME.md"
echo "   Plan: $WORKSPACE/projects/planning/$PROJECT_NAME-plan.md"
echo "   Context: $WORKSPACE/agents/contexts/$PROJECT_NAME-context.md"
echo "   MCP Config: $WORKSPACE/workflows/mcp-configs/$PROJECT_NAME.json"
echo
echo -e "${YELLOW}🚀 Next Steps:${NC}"
echo "1. cd $PROJECT_PATH"
echo "2. claude-code \"Help me set up $PROJECT_NAME project\""
echo "3. Start coding!"
echo
echo -e "${GREEN}Happy coding! 🎉${NC}"