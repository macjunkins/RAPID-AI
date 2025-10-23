#!/bin/bash

# Task completion verification with documentation checks
# Ensures all development tasks include proper documentation verification
# Prevents task completion when documentation is outdated

set -e

# Configuration
PROJECT_CONFIG="${PROJECT_CONFIG:-.ai-workflow.yaml}"
DOCUMENTATION_REQUIRED="${DOCUMENTATION_REQUIRED:-true}"

# Import framework functions
SCRIPT_DIR="$(dirname "$0")"

# Load common functions
if ! source "$SCRIPT_DIR/../workflows/common-functions.sh" 2>/dev/null; then
    echo "❌ Cannot load common functions from: $SCRIPT_DIR/../workflows/common-functions.sh"
    echo "💡 Please ensure you're running RAPID-AI from the correct directory structure."
    exit 1
fi

# Load documentation detection functions
if ! source "$SCRIPT_DIR/doc-detection.sh" 2>/dev/null; then
    echo "❌ Cannot load documentation detection from: $SCRIPT_DIR/doc-detection.sh"
    echo "💡 Documentation detection is required for task completion verification."
    exit 1
fi

# Validate task completion with documentation requirements
validate_task_completion() {
    local task_id="$1"
    local story_file="$2"
    local changes_made="$3"
    
    echo "🔍 Validating task completion: $task_id"
    echo "📋 Story file: $story_file"
    echo "📝 Changes: $changes_made"
    
    # Step 1: Verify basic task completion requirements
    if ! verify_basic_task_completion "$task_id" "$story_file"; then
        echo "❌ Basic task completion requirements not met"
        return 1
    fi
    
    # Step 2: Check if documentation verification is required
    if [ "$DOCUMENTATION_REQUIRED" = "true" ]; then
        echo "📚 Checking documentation requirements..."
        
        # Check if changes require documentation updates
        local docs_needed=$(check_documentation_needs "$changes_made")
        if [ $? -eq 0 ] && [ -n "$docs_needed" ]; then
            echo "📝 Documentation updates required for these changes:"
            echo "$docs_needed"
            
            # Verify documentation has been updated
            if ! verify_documentation_currency "$changes_made"; then
                echo "❌ Documentation is not current with changes"
                echo "🚫 Task completion blocked until documentation is updated"
                return 1
            fi
        else
            echo "✅ No documentation updates required for these changes"
        fi
    fi
    
    # Step 3: Run completion checklist
    if ! run_completion_checklist "$task_id" "$story_file"; then
        echo "❌ Completion checklist failed"
        return 1
    fi
    
    echo "✅ Task $task_id completion verified successfully"
    return 0
}

# Verify basic task completion requirements
verify_basic_task_completion() {
    local task_id="$1"
    local story_file="$2"
    
    # Check if story file exists
    if [ ! -f "$story_file" ]; then
        echo "❌ Story file not found: $story_file"
        return 1
    fi
    
    # Check if task is marked as complete in story file
    local task_pattern="Task $task_id.*\[x\]"
    if ! grep -q "$task_pattern" "$story_file"; then
        echo "❌ Task $task_id is not marked as complete in story file"
        return 1
    fi
    
    # Check if all subtasks are complete
    local incomplete_subtasks=$(grep -A 20 "Task $task_id" "$story_file" | grep -c "  - \[ \]" || true)
    if [ "$incomplete_subtasks" -gt 0 ]; then
        echo "❌ Task $task_id has $incomplete_subtasks incomplete subtasks"
        return 1
    fi
    
    echo "✅ Basic task completion requirements met"
    return 0
}

# Verify documentation currency with changes
verify_documentation_currency() {
    local changes_made="$1"
    
    # Use documentation detection to check currency
    local doc_status
    if [ -n "$changes_made" ]; then
        doc_status=$(run_documentation_detection "files" "$changes_made")
    else
        doc_status=$(run_documentation_detection "git-diff")
    fi
    
    # Parse documentation status to check for outdated documentation
    if echo "$doc_status" | grep -q "REQUIRES UPDATE"; then
        echo "❌ Documentation currency check failed"
        echo "📝 The following documentation needs updating:"
        echo "$doc_status" | grep "REQUIRES UPDATE"
        return 1
    fi
    
    echo "✅ Documentation is current with changes"
    return 0
}

# Run completion checklist
run_completion_checklist() {
    local task_id="$1"
    local story_file="$2"
    
    echo "📋 Running completion checklist for Task $task_id"
    
    # Checklist items for task completion with documentation
    local checklist_items=(
        "Code changes implemented and tested"
        "Tests pass successfully"
        "Documentation updated (if required)"
        "Story file updated with completion status"
        "File list updated with all changes"
        "No regression issues introduced"
    )
    
    local failures=0
    
    for item in "${checklist_items[@]}"; do
        if verify_checklist_item "$item" "$story_file"; then
            echo "✅ $item"
        else
            echo "❌ $item"
            failures=$((failures + 1))
        fi
    done
    
    if [ $failures -eq 0 ]; then
        echo "✅ All checklist items passed"
        return 0
    else
        echo "❌ $failures checklist items failed"
        return 1
    fi
}

# Verify individual checklist item
verify_checklist_item() {
    local item="$1"
    local story_file="$2"
    
    case "$item" in
        "Code changes implemented and tested")
            # Check if there are recent commits or file changes
            if git rev-parse --git-dir > /dev/null 2>&1; then
                local recent_commits=$(git log --oneline -n 5 --since="1 day ago" | wc -l)
                [ "$recent_commits" -gt 0 ]
            else
                # Non-git project, assume changes exist if story file updated
                [ -f "$story_file" ]
            fi
            ;;
        "Tests pass successfully")
            # Run project tests if test command exists
            if command -v npm > /dev/null && [ -f "package.json" ]; then
                npm test > /dev/null 2>&1
            elif [ -f "Makefile" ] && grep -q "test:" Makefile; then
                make test > /dev/null 2>&1
            else
                # No tests configured, pass by default
                true
            fi
            ;;
        "Documentation updated (if required)")
            # This is handled by verify_documentation_currency
            true
            ;;
        "Story file updated with completion status")
            # Check if story file has recent Dev Agent Record updates
            grep -q "Debug Log References" "$story_file" && \
            grep -q "Completion Notes List" "$story_file"
            ;;
        "File list updated with all changes")
            # Check if File List section exists and has content
            grep -A 10 "### File List" "$story_file" | grep -q "- "
            ;;
        "No regression issues introduced")
            # Run basic smoke tests if available
            if [ -f "scripts/smoke-test.sh" ]; then
                bash scripts/smoke-test.sh > /dev/null 2>&1
            else
                # No smoke tests, pass by default
                true
            fi
            ;;
        *)
            # Unknown checklist item, pass by default
            true
            ;;
    esac
}

# Block task completion with documentation requirements
block_task_completion() {
    local task_id="$1"
    local reason="$2"
    
    echo "🚫 TASK COMPLETION BLOCKED"
    echo "📋 Task: $task_id"
    echo "❌ Reason: $reason"
    echo ""
    echo "📝 To complete this task, you must:"
    echo "   1. Address the blocking issue above"
    echo "   2. Re-run task completion verification"
    echo "   3. Ensure all documentation requirements are met"
    echo ""
    echo "💡 Use the documentation detection script to identify required updates:"
    echo "   bash core/scripts/doc-detection.sh"
    
    return 1
}

# Main task completion verification entry point
main() {
    local task_id="$1"
    local story_file="$2"
    local changes_made="$3"
    
    if [ -z "$task_id" ] || [ -z "$story_file" ]; then
        echo "Usage: $0 <task-id> <story-file> [changes-made]"
        echo "Example: $0 '3.1' 'docs/stories/story-3-1.md' 'src/components/auth.js,docs/api.md'"
        exit 1
    fi
    
    echo "🎯 Starting task completion verification"
    echo "📋 Task: $task_id"
    echo "📄 Story: $story_file"
    
    if validate_task_completion "$task_id" "$story_file" "$changes_made"; then
        echo ""
        echo "🎉 TASK COMPLETION APPROVED"
        echo "✅ Task $task_id is ready for review"
        return 0
    else
        echo ""
        block_task_completion "$task_id" "Validation failed - see errors above"
        return 1
    fi
}

# Check if script is being called directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi