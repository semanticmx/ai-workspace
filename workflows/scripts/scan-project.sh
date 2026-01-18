#!/bin/bash

# AI Workspace - Existing Project Scanner
# Usage: ./scan-project.sh /path/to/project

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
WORKSPACE="${AI_WORKSPACE:-$HOME/ai-workspace}"
PROJECT_PATH=$1

# Validate inputs
if [ -z "$PROJECT_PATH" ]; then
    echo -e "${RED}Error: Project path required${NC}"
    echo "Usage: $0 /path/to/existing/project"
    exit 1
fi

if [ ! -d "$PROJECT_PATH" ]; then
    echo -e "${RED}Error: Directory does not exist: $PROJECT_PATH${NC}"
    exit 1
fi

PROJECT_NAME=$(basename "$PROJECT_PATH")
echo -e "${BLUE}🔍 Scanning project: $PROJECT_NAME${NC}"
echo -e "${YELLOW}Path: $PROJECT_PATH${NC}"

# Detect project type
echo -e "${GREEN}🔎 Detecting project type...${NC}"
PROJECT_TYPE="unknown"

if [ -f "$PROJECT_PATH/package.json" ]; then
    if grep -q "react" "$PROJECT_PATH/package.json" 2>/dev/null; then
        PROJECT_TYPE="react"
    elif grep -q "vue" "$PROJECT_PATH/package.json" 2>/dev/null; then
        PROJECT_TYPE="vue"
    elif grep -q "express" "$PROJECT_PATH/package.json" 2>/dev/null; then
        PROJECT_TYPE="node-api"
    else
        PROJECT_TYPE="node"
    fi
elif [ -f "$PROJECT_PATH/requirements.txt" ] || [ -f "$PROJECT_PATH/pyproject.toml" ]; then
    PROJECT_TYPE="python"
elif [ -f "$PROJECT_PATH/go.mod" ]; then
    PROJECT_TYPE="go"
elif [ -f "$PROJECT_PATH/Cargo.toml" ]; then
    PROJECT_TYPE="rust"
elif [ -f "$PROJECT_PATH/pom.xml" ] || [ -f "$PROJECT_PATH/build.gradle" ]; then
    PROJECT_TYPE="java"
fi

echo "Detected type: $PROJECT_TYPE"

# Create project profile
echo -e "${GREEN}📄 Creating project profile...${NC}"
PROFILE_PATH="$WORKSPACE/projects/planning/$PROJECT_NAME-profile.md"

cat > "$PROFILE_PATH" << EOF
# Project Profile: $PROJECT_NAME

## Scan Date
$(date '+%Y-%m-%d %H:%M:%S')

## Project Information
- **Path**: $PROJECT_PATH
- **Type**: $PROJECT_TYPE
- **Size**: $(du -sh "$PROJECT_PATH" 2>/dev/null | cut -f1)

## Directory Structure
\`\`\`
$(tree -L 2 "$PROJECT_PATH" 2>/dev/null || find "$PROJECT_PATH" -maxdepth 2 -type d | head -20)
\`\`\`

## File Statistics
- Total files: $(find "$PROJECT_PATH" -type f | wc -l)
- Code files: $(find "$PROJECT_PATH" -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.go" \) | wc -l)
- Test files: $(find "$PROJECT_PATH" -type f -name "*test*" | wc -l)

EOF

# Add package information based on type
case $PROJECT_TYPE in
    "react"|"vue"|"node"|"node-api")
        echo "## Package Information" >> "$PROFILE_PATH"
        echo '```json' >> "$PROFILE_PATH"
        jq '{name, version, description, scripts, dependencies: .dependencies | keys, devDependencies: .devDependencies | keys}' "$PROJECT_PATH/package.json" 2>/dev/null >> "$PROFILE_PATH" || echo "Unable to parse package.json" >> "$PROFILE_PATH"
        echo '```' >> "$PROFILE_PATH"
        ;;
    "python")
        echo "## Python Dependencies" >> "$PROFILE_PATH"
        echo '```' >> "$PROFILE_PATH"
        if [ -f "$PROJECT_PATH/requirements.txt" ]; then
            head -20 "$PROJECT_PATH/requirements.txt" >> "$PROFILE_PATH"
        elif [ -f "$PROJECT_PATH/pyproject.toml" ]; then
            grep -A 20 "dependencies" "$PROJECT_PATH/pyproject.toml" >> "$PROFILE_PATH"
        fi
        echo '```' >> "$PROFILE_PATH"
        ;;
    "go")
        echo "## Go Modules" >> "$PROFILE_PATH"
        echo '```' >> "$PROFILE_PATH"
        head -20 "$PROJECT_PATH/go.mod" >> "$PROFILE_PATH"
        echo '```' >> "$PROFILE_PATH"
        ;;
esac

# Extract TODOs and FIXMEs
echo -e "${GREEN}📝 Extracting TODOs and issues...${NC}"
TODO_FILE="$WORKSPACE/todos/active/$PROJECT_NAME-imported.md"

cat > "$TODO_FILE" << EOF
# Imported TODOs: $PROJECT_NAME
Scanned: $(date '+%Y-%m-%d')
Path: $PROJECT_PATH

## Found in Code

EOF

# Search for TODOs, FIXMEs, etc.
grep -rn "TODO\|FIXME\|XXX\|HACK\|NOTE" "$PROJECT_PATH" \
    --include="*.js" --include="*.ts" --include="*.jsx" --include="*.tsx" \
    --include="*.py" --include="*.go" --include="*.java" --include="*.rs" \
    --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=dist \
    2>/dev/null | head -50 | while IFS=: read -r file line content; do
    REL_PATH=${file#$PROJECT_PATH/}
    echo "- [ ] \`$REL_PATH:$line\` - $content" >> "$TODO_FILE"
done || echo "No TODOs found in code" >> "$TODO_FILE"

# Create MCP configuration
echo -e "${GREEN}⚙️ Creating MCP configuration...${NC}"
MCP_CONFIG="$WORKSPACE/workflows/mcp-configs/$PROJECT_NAME.json"

cat > "$MCP_CONFIG" << EOF
{
  "mcpServers": {
    "project": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem"],
      "env": {
        "ALLOWED_DIRECTORIES": "$PROJECT_PATH,$WORKSPACE"
      }
    }
EOF

# Add database config if detected
if grep -q "postgres\|postgresql" "$PROJECT_PATH"/*.{json,yml,yaml,env,config} 2>/dev/null; then
    cat >> "$MCP_CONFIG" << EOF
,
    "database": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "\${DATABASE_URL}"
      }
    }
EOF
fi

# Add GitHub if .git exists
if [ -d "$PROJECT_PATH/.git" ]; then
    REMOTE_URL=$(cd "$PROJECT_PATH" && git remote get-url origin 2>/dev/null || echo "")
    if [[ $REMOTE_URL == *"github.com"* ]]; then
        cat >> "$MCP_CONFIG" << EOF
,
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "\${GITHUB_TOKEN}"
      }
    }
EOF
    fi
fi

echo "  }" >> "$MCP_CONFIG"
echo "}" >> "$MCP_CONFIG"

# Create project context
echo -e "${GREEN}🤖 Creating AI context...${NC}"
CONTEXT_FILE="$WORKSPACE/agents/contexts/$PROJECT_NAME-context.md"

cat > "$CONTEXT_FILE" << EOF
# Context: $PROJECT_NAME

## Import Date
$(date '+%Y-%m-%d %H:%M:%S')

## Project Information
- **Type**: $PROJECT_TYPE
- **Path**: $PROJECT_PATH
- **Repository**: $(cd "$PROJECT_PATH" && git remote get-url origin 2>/dev/null || echo "No git remote")

## Technology Stack
EOF

# Detect technologies
if [ -f "$PROJECT_PATH/package.json" ]; then
    echo "### Frontend/Node.js" >> "$CONTEXT_FILE"
    jq -r '.dependencies | keys[]' "$PROJECT_PATH/package.json" 2>/dev/null | head -10 | sed 's/^/- /' >> "$CONTEXT_FILE"
fi

if [ -f "$PROJECT_PATH/requirements.txt" ]; then
    echo "### Python" >> "$CONTEXT_FILE"
    head -10 "$PROJECT_PATH/requirements.txt" | sed 's/^/- /' >> "$CONTEXT_FILE"
fi

cat >> "$CONTEXT_FILE" << EOF

## Key Files and Directories
$(find "$PROJECT_PATH" -maxdepth 2 -type f \( -name "*.config.*" -o -name ".*rc" -o -name "Dockerfile" \) | head -10 | sed 's/^/- /')

## Development Commands
EOF

# Extract npm scripts if available
if [ -f "$PROJECT_PATH/package.json" ]; then
    echo '```bash' >> "$CONTEXT_FILE"
    jq -r '.scripts | to_entries[] | "npm run \(.key)  # \(.value)"' "$PROJECT_PATH/package.json" 2>/dev/null | head -10 >> "$CONTEXT_FILE"
    echo '```' >> "$CONTEXT_FILE"
fi

# Create initial task list
echo -e "${GREEN}✅ Creating task list...${NC}"
TASK_FILE="$WORKSPACE/todos/active/$PROJECT_NAME-tasks.md"

cat > "$TASK_FILE" << EOF
# Tasks: $PROJECT_NAME

## 🔍 Analysis Tasks
- [ ] Review project structure and architecture
- [ ] Identify areas for improvement
- [ ] Check for security vulnerabilities
- [ ] Analyze code quality
- [ ] Review test coverage

## 🛠️ Setup Tasks
- [ ] Set up local development environment
- [ ] Configure AI workspace integration
- [ ] Create development documentation
- [ ] Set up automated workflows

## 📚 Documentation Tasks
- [ ] Create/update README
- [ ] Document API endpoints (if applicable)
- [ ] Create architecture diagram
- [ ] Write setup guide
EOF

# Summary
echo
echo -e "${GREEN}✅ Project scan complete!${NC}"
echo
echo -e "${BLUE}📊 Scan Results:${NC}"
echo "   Type: $PROJECT_TYPE"
echo "   Profile: $PROFILE_PATH"
echo "   TODOs: $TODO_FILE"
echo "   Tasks: $TASK_FILE"
echo "   Context: $CONTEXT_FILE"
echo "   MCP Config: $MCP_CONFIG"
echo
echo -e "${YELLOW}📋 Summary:${NC}"
echo "   - $(grep -c "^- \[ \]" "$TODO_FILE" 2>/dev/null || echo "0") TODOs found in code"
echo "   - $(find "$PROJECT_PATH" -type f | wc -l) total files"
echo "   - Configuration created for Claude integration"
echo
echo -e "${GREEN}🚀 Next Steps:${NC}"
echo "1. Review the generated files"
echo "2. Copy MCP config: cp $MCP_CONFIG ~/.config/claude-code/config.json"
echo "3. Start working: claude-code \"Help me with $PROJECT_NAME project\""
echo
echo -e "${GREEN}Project imported successfully! 🎉${NC}"