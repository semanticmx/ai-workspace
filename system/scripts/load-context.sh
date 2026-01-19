#!/bin/bash

# Context Loading System for Claude
# This script generates the appropriate context for Claude based on current location

WORKSPACE="${AI_WORKSPACE:-$HOME/ai-workspace}"
CURRENT_DIR=$(pwd)

# Function to load context files
load_context() {
    local context=""

    # Always load global context
    if [ -f "$WORKSPACE/global/CLAUDE-GLOBAL.md" ]; then
        context+="=== GLOBAL CONTEXT ===\n"
        context+=$(cat "$WORKSPACE/global/CLAUDE-GLOBAL.md")
        context+="\n\n"
    fi

    # Load all global rules
    if [ -d "$WORKSPACE/global/rules" ]; then
        context+="=== GLOBAL RULES ===\n"
        for rule in "$WORKSPACE/global/rules"/*.md; do
            if [ -f "$rule" ]; then
                context+="--- $(basename $rule .md) ---\n"
                context+=$(cat "$rule")
                context+="\n\n"
            fi
        done
    fi

    # Check if we're in a GitHub project
    if [[ "$CURRENT_DIR" == *"/GitHub/"* ]] && [ -f ".claude/workspace-link" ]; then
        PROJECT_WORKSPACE=$(cat .claude/workspace-link)

        # Load project-specific context
        if [ -f "$PROJECT_WORKSPACE/claude/CLAUDE.md" ]; then
            context+="=== PROJECT CONTEXT ===\n"
            context+=$(cat "$PROJECT_WORKSPACE/claude/CLAUDE.md")
            context+="\n\n"
        fi

        # Load project planning docs
        if [ -d "$PROJECT_WORKSPACE/planning" ]; then
            context+="=== PROJECT PLANNING ===\n"
            for doc in "$PROJECT_WORKSPACE/planning"/*.md; do
                if [ -f "$doc" ]; then
                    context+="--- $(basename $doc) ---\n"
                    context+=$(head -50 "$doc")
                    context+="\n...\n\n"
                fi
            done
        fi
    fi

    # Check for local CLAUDE.md
    if [ -f "CLAUDE.md" ]; then
        context+="=== LOCAL CONTEXT ===\n"
        context+=$(cat CLAUDE.md)
        context+="\n\n"
    fi

    echo -e "$context"
}

# Generate MCP config
generate_mcp_config() {
    local config="{\"mcpServers\":{"

    # Load global MCP
    if [ -f "$WORKSPACE/global/mcp/default.json" ]; then
        config+=$(jq -r '.mcpServers | to_entries | map("\"\(.key)\":\(.value)") | join(",")' "$WORKSPACE/global/mcp/default.json")
    fi

    # Add project-specific MCP if in project
    if [ -f ".claude/project.json" ]; then
        local project_servers=$(jq -r '.mcpServers | to_entries | map("\"\(.key)\":\(.value)") | join(",")' .claude/project.json)
        if [ ! -z "$project_servers" ]; then
            config+=",$project_servers"
        fi
    fi

    config+="}}"
    echo "$config" | jq '.'
}

# Main execution
case "${1:-context}" in
    context)
        load_context
        ;;
    mcp)
        generate_mcp_config
        ;;
    all)
        echo "=== CONTEXT ==="
        load_context
        echo "=== MCP CONFIG ==="
        generate_mcp_config
        ;;
    *)
        echo "Usage: $0 [context|mcp|all]"
        ;;
esac