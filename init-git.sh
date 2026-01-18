#!/bin/bash

# Initialize git repository for AI Workspace
# This script sets up the main repository structure

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🚀 Initializing AI Workspace Git Repository${NC}"

# Initialize git if not already initialized
if [ ! -d ".git" ]; then
    git init
    echo -e "${GREEN}✅ Git repository initialized${NC}"
else
    echo -e "${YELLOW}ℹ️  Git repository already exists${NC}"
fi

# Add all system files (projects are ignored by .gitignore)
git add .

# Show what will be committed
echo -e "${BLUE}📋 Files to be committed:${NC}"
git status --short

echo -e "${YELLOW}
Next steps:
1. Review the files to be committed
2. Create initial commit:
   git commit -m \"Initial AI Workspace setup\"

3. Add remote repository (optional):
   git remote add origin <your-repo-url>
   git push -u origin main

4. For each project, decide on git strategy:
   - Separate repo: Initialize git in projects/<name>/
   - Submodule: Use git submodule add
   - Local only: Do nothing (already ignored)

See projects/README.md for detailed instructions.
${NC}"