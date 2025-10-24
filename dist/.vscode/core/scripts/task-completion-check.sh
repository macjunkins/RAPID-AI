#!/bin/bash

# Task Completion Verification Script
# Ensures documentation is current before allowing task completion
# Implements documentation-as-you-go workflow integration

set -e

# Configuration
FORCE_COMPLETION=false
TASK_NAME=""
CHANGED_FILES=""

# Import framework functions
SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/../workflows/common-functions.sh"

# Usage information
show_usage() {
    cat << 'USAGE'
Task Completion Verification Script

USAGE:
    task-completion-check.sh [OPTIONS] [FILES...]

OPTIONS:
    -f, --force          Force completion without documentation verification
    -t, --task-name NAME Specify task name for reporting
    -h, --help          Show this help message

ARGUMENTS:
    FILES...            List of changed files to verify (optional)
                       If not provided, will check git changes automatically

EXAMPLES:
    # Check current git changes
    ./core/scripts/task-completion-check.sh

    # Check specific files
    ./core/scripts/task-completion-check.sh src/main.js docs/api.md

    # Force completion (skip documentation verification)
    ./core/scripts/task-completion-check.sh --force

    # Check with custom task name
    ./core/scripts/task-completion-check.sh --task-name "User Authentication" src/auth.js

DESCRIPTION:
    This script verifies that documentation is current before allowing task completion.
    It checks if any changed files require documentation updates and blocks completion
    until documentation requirements are met.

    The script integrates with the documentation-as-you-go workflow to ensure
    user documentation stays current with development activities.

EXIT CODES:
    0 - Task completion allowed (documentation is current)
    1 - Task completion blocked (documentation updates required)
    2 - Script error or invalid usage
USAGE
}

# Parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -f|--force)
                FORCE_COMPLETION=true
                shift
                ;;
            -t|--task-name)
                TASK_NAME="$2"
                shift 2
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            -*)
                echo "❌ Unknown option: $1"
                echo "💡 Use --help for usage information"
                exit 2
                ;;
            *)
                # Collect file arguments
                if [ -z "$CHANGED_FILES" ]; then
                    CHANGED_FILES="$1"
                else
                    CHANGED_FILES="$CHANGED_FILES,$1"
                fi
                shift
                ;;
        esac
    done
}

# Detect changed files automatically if not provided
detect_changed_files() {
    if [ -z "$CHANGED_FILES" ]; then
        echo "🔍 No files specified, detecting changes automatically..."
        
        if command -v git &> /dev/null && git rev-parse --git-dir > /dev/null 2>&1; then
            # Get files changed in current branch
            local git_changes=$(git diff --name-only HEAD~1..HEAD 2>/dev/null || git diff --name-only --cached 2>/dev/null || true)
            
            if [ -n "$git_changes" ]; then
                CHANGED_FILES=$(echo "$git_changes" | tr '\n' ',' | sed 's/,$//')
                echo "📝 Detected git changes: $(echo "$git_changes" | wc -l) files"
            else
                echo "📋 No git changes detected"
            fi
        else
            echo "⚠️ Not in a git repository - manual file specification required"
        fi
    fi
}

# Main execution
main() {
    echo "🎯 RAPID-AI Task Completion Verification"
    echo "========================================"
    
    # Validate environment
    if ! validate_environment "$SCRIPT_DIR"; then
        echo "❌ Environment validation failed"
        exit 2
    fi
    
    # Detect changed files if needed
    detect_changed_files
    
    # Set default task name if not provided
    if [ -z "$TASK_NAME" ]; then
        TASK_NAME="current development task"
    fi
    
    echo ""
    echo "📋 Task: $TASK_NAME"
    echo "📁 Changed files: ${CHANGED_FILES:-"none specified"}"
    echo "🚀 Force completion: $FORCE_COMPLETION"
    echo ""
    
    # Run comprehensive task completion verification
    if verify_task_completion "$CHANGED_FILES" "$FORCE_COMPLETION" "$TASK_NAME"; then
        echo ""
        echo "🎉 SUCCESS: Task completion verification passed!"
        echo "✅ You may now mark your task as complete."
        echo ""
        echo "📋 Remember to:"
        echo "  • Update task status in your project management system"
        echo "  • Commit any remaining changes"
        echo "  • Create pull request if working on a feature branch"
        echo "  • Update team on task completion"
        exit 0
    else
        echo ""
        echo "❌ BLOCKED: Task completion verification failed!"
        echo "📝 Please address the documentation requirements above."
        echo ""
        echo "💡 Options:"
        echo "  • Update the required documentation files"
        echo "  • Run this script again after updates"
        echo "  • Use --force flag to bypass verification (not recommended)"
        exit 1
    fi
}

# Validate inputs and environment
validate_inputs() {
    # Check if we're in the right directory structure
    if [ ! -d "$SCRIPT_DIR/../workflows" ]; then
        echo "❌ Invalid directory structure"
        echo "💡 Please run this script from the RAPID-AI project root"
        echo "📋 Expected: core/scripts/ and core/workflows/ directories"
        exit 2
    fi
    
    # Check if documentation detection is available
    if [ ! -f "$SCRIPT_DIR/doc-detection.sh" ]; then
        echo "⚠️ Documentation detection script not found"
        echo "💡 Some features may not work correctly"
    fi
}

# Check if script is being called directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    parse_arguments "$@"
    validate_inputs
    main
fi
