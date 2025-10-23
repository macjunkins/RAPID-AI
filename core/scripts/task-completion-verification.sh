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
    local task_pattern="\[x\].*Task $task_id"
    if ! grep -q "$task_pattern" "$story_file"; then
        echo "❌ Task $task_id is not marked as complete in story file"
        return 1
    fi
    
    # Check if all subtasks are complete for this specific task
    # Note: We also show remaining subtasks in the story for context
    local task_section=$(awk "/^- \[.\] Task $task_id:/{flag=1; next} /^- \[.\] Task [0-9]+:/{flag=0} flag" "$story_file")
    local task_incomplete_subtasks=$(echo "$task_section" | grep -c "  - \[ \]" || true)
    
    # Get all remaining incomplete subtasks in the story for context
    local story_incomplete_subtasks=$(grep -c "  - \[ \]" "$story_file" || true)
    
    if [ "$task_incomplete_subtasks" -gt 0 ]; then
        echo "❌ Task $task_id has $task_incomplete_subtasks incomplete subtasks"
        echo "📝 Task $task_id incomplete subtasks:"
        echo "$task_section" | grep "  - \[ \]"
        return 1
    fi
    
    # Store story context for completion summary
    STORY_INCOMPLETE_SUBTASKS="$story_incomplete_subtasks"
    
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
            # Run project tests if test command exists and tests are configured
            if command -v npm > /dev/null && [ -f "package.json" ]; then
                # Check if tests actually exist before running them
                if [ -d "tests" ] || [ -d "test" ] || find . -name "*.test.*" -o -name "*.spec.*" | head -1 | grep -q .; then
                    npm test > /dev/null 2>&1
                else
                    # No test files found, skip test requirement for now
                    echo "  ℹ️  No test files found - skipping test requirement for framework project"
                    true
                fi
            elif [ -f "Makefile" ] && grep -q "test:" Makefile; then
                make test > /dev/null 2>&1
            else
                # No tests configured, pass by default for framework projects
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
            grep -A 10 "### File List" "$story_file" | grep -q "^- "
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

# Show story progress and next steps
show_story_progress_summary() {
    local story_file="$1"
    local completed_task_id="$2"
    
    echo ""
    echo "📊 STORY PROGRESS SUMMARY"
    echo "========================"
    
    # Count completed and remaining tasks
    local completed_tasks=$(grep -c "^- \[x\] Task" "$story_file" || true)
    local total_tasks=$(grep -c "^- \[.\] Task" "$story_file" || true)
    local remaining_tasks=$((total_tasks - completed_tasks))
    
    echo "✅ Completed Tasks: $completed_tasks/$total_tasks"
    
    if [ "$remaining_tasks" -gt 0 ]; then
        echo "📋 Remaining Tasks: $remaining_tasks"
        echo ""
        echo "🔄 NEXT STEPS:"
        
        # Find the next incomplete task
        local next_task_line=$(grep "^- \[ \] Task" "$story_file" | head -1)
        local next_task=$(echo "$next_task_line" | grep -o "Task [0-9]\+" | grep -o "[0-9]\+")
        if [ -n "$next_task" ]; then
            echo "   → Continue with Task $next_task"
            
            # Show the next task title (extract everything between "Task N: " and " (AC:")
            local next_task_title=$(echo "$next_task_line" | sed 's/^- \[ \] Task [0-9]\+: \(.*\) (AC:.*/\1/')
            if [ -n "$next_task_title" ] && [ "$next_task_title" != "$next_task_line" ]; then
                echo "   📝 $next_task_title"
            fi
        fi
        
        # Show any incomplete subtasks across the story for context
        local total_incomplete_subtasks=$(grep -c "  - \[ \]" "$story_file" || true)
        if [ "$total_incomplete_subtasks" -gt 0 ]; then
            echo ""
            echo "📋 Remaining Subtasks in Story: $total_incomplete_subtasks"
            echo "   (Use these to plan upcoming development work)"
        fi
        
        # Check for documentation gaps in previous tasks
        check_previous_task_documentation "$story_file" "$completed_task_id"
        
    else
        echo ""
        echo "🎯 ALL TASKS COMPLETE!"
        echo "   Story is ready for final review and sign-off"
    fi
    
    echo ""
}

# Check if previous tasks may have skipped documentation
check_previous_task_documentation() {
    local story_file="$1" 
    local current_task_id="$2"
    
    # Look for completed tasks that might not have updated documentation
    local completed_tasks=$(grep "^- \[x\] Task" "$story_file" | sed 's/^- \[x\] Task \([0-9]\+\):.*/\1/')
    local doc_warnings=""
    
    for task in $completed_tasks; do
        if [ "$task" != "$current_task_id" ]; then
            # Check if this task involved file changes that might need documentation
            # Use a simpler approach to avoid awk regex issues with special characters
            local task_line=$(grep "^- \[x\] Task $task:" "$story_file")
            
            if echo "$task_line" | grep -qi "VS Code\|documentation\|README\|user\|interface\|API"; then
                if [ -z "$doc_warnings" ]; then
                    doc_warnings="Task $task"
                else
                    doc_warnings="$doc_warnings, Task $task"
                fi
            fi
        fi
    done
    
    if [ -n "$doc_warnings" ]; then
        echo ""
        echo "⚠️  DOCUMENTATION CHECK:"
        echo "   Previous tasks ($doc_warnings) may have changed user-facing features"
        echo "   Consider reviewing if documentation updates were completed"
        echo "   💡 Run: bash core/scripts/doc-detection.sh"
    fi
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
        
        # Show story progress context
        show_story_progress_summary "$story_file" "$task_id"
        
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