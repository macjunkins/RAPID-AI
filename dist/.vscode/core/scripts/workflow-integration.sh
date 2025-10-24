#!/bin/bash

# Workflow integration for documentation verification
# Integrates documentation checks into existing RAPID-AI development workflows
# Provides wrapper functions for enhanced task completion

set -e

# Configuration
SCRIPT_DIR="$(dirname "$0")"

# Load required dependencies
source "$SCRIPT_DIR/../workflows/common-functions.sh"
source "$SCRIPT_DIR/doc-detection.sh"

# Enhanced story analysis with documentation detection
enhanced_story_analysis() {
    local epic="$1"
    local story="$2"
    local title="$3"
    local output_file="$4"
    
    echo "🚀 Running enhanced story analysis with documentation verification"
    
    # Run original AI discovery
    if ! bash "$SCRIPT_DIR/ai-discovery.sh" "$epic" "$story" "$title" "$output_file"; then
        echo "❌ Story analysis failed"
        return 1
    fi
    
    # Add documentation analysis to the output
    echo "" >> "$output_file"
    echo "## Documentation Requirements Analysis" >> "$output_file"
    echo "" >> "$output_file"
    echo "Generated on: $(date)" >> "$output_file"
    echo "" >> "$output_file"
    
    # Analyze documentation requirements for this story
    local story_context="Story $epic.$story: $title"
    echo "### Documentation Detection Results" >> "$output_file"
    echo "" >> "$output_file"
    echo "\`\`\`" >> "$output_file"
    run_documentation_detection "suggestions" "$story_context" >> "$output_file"
    echo "\`\`\`" >> "$output_file"
    echo "" >> "$output_file"
    
    echo "### Recommended Documentation Updates" >> "$output_file"
    echo "" >> "$output_file"
    echo "Based on this story's requirements, the following documentation may need updates:" >> "$output_file"
    echo "" >> "$output_file"
    
    # Generate documentation recommendations
    suggest_documentation_updates "$story_context" >> "$output_file"
    
    echo "✅ Enhanced story analysis complete with documentation guidance"
}

# Enhanced implementation planning with documentation checks
enhanced_implementation_planning() {
    local epic="$1"
    local story="$2"
    local title="$3"
    local discovery_file="$4"
    local plan_file="$5"
    
    echo "📋 Running enhanced implementation planning with documentation verification"
    
    # Run original implementation planning
    if ! bash "$SCRIPT_DIR/ai-implementation-plan.sh" "$epic" "$story" "$title" "$discovery_file" "$plan_file"; then
        echo "❌ Implementation planning failed"
        return 1
    fi
    
    # Add documentation planning section
    echo "" >> "$plan_file"
    echo "## Documentation Implementation Plan" >> "$plan_file"
    echo "" >> "$plan_file"
    echo "### Documentation Tasks" >> "$plan_file"
    echo "" >> "$plan_file"
    echo "The following documentation tasks should be completed as part of this story:" >> "$plan_file"
    echo "" >> "$plan_file"
    
    # Generate documentation tasks based on story requirements
    generate_documentation_tasks "$epic" "$story" "$title" >> "$plan_file"
    
    echo "" >> "$plan_file"
    echo "### Documentation Verification Checklist" >> "$plan_file"
    echo "" >> "$plan_file"
    echo "- [ ] All user-facing changes documented" >> "$plan_file"
    echo "- [ ] API changes reflected in documentation" >> "$plan_file"
    echo "- [ ] Configuration changes documented" >> "$plan_file"
    echo "- [ ] Breaking changes highlighted" >> "$plan_file"
    echo "- [ ] Examples updated with new functionality" >> "$plan_file"
    echo "- [ ] Documentation builds and links work correctly" >> "$plan_file"
    echo "" >> "$plan_file"
    
    echo "✅ Enhanced implementation planning complete with documentation requirements"
}

# Generate documentation tasks for a story
generate_documentation_tasks() {
    local epic="$1"
    local story="$2"
    local title="$3"
    
    echo "1. **Pre-Implementation Documentation Review**"
    echo "   - Review current documentation relevant to: $title"
    echo "   - Identify documentation sections that will be affected"
    echo "   - Plan documentation changes alongside code changes"
    echo ""
    echo "2. **Implementation Documentation Updates**"
    echo "   - Update documentation as features are implemented"
    echo "   - Add new documentation sections for new functionality"
    echo "   - Update examples and code snippets"
    echo ""
    echo "3. **Post-Implementation Documentation Verification**"
    echo "   - Run documentation verification: \`bash core/scripts/task-completion-verification.sh \"$epic.$story\" \"docs/stories/$epic.$story.md\"\`"
    echo "   - Ensure all documentation is current and accurate"
    echo "   - Verify documentation builds without errors"
    echo ""
}

# Integrated task completion with documentation
integrated_task_completion() {
    local task_id="$1"
    local story_file="$2"
    local changes_made="$3"
    
    echo "🎯 Running integrated task completion with documentation verification"
    
    # Run task completion verification
    if bash "$SCRIPT_DIR/task-completion-verification.sh" "$task_id" "$story_file" "$changes_made"; then
        echo "✅ Task completion verification passed"
        
        # Update story file with completion
        update_story_completion "$task_id" "$story_file" "$changes_made"
        
        echo "🎉 Task $task_id completed successfully with documentation verification"
        return 0
    else
        echo "❌ Task completion verification failed"
        echo "📝 Documentation requirements not met - task completion blocked"
        return 1
    fi
}

# Update story file with completion information
update_story_completion() {
    local task_id="$1"
    local story_file="$2"
    local changes_made="$3"
    
    echo "📝 Updating story file with completion information"
    
    # Create backup of story file
    cp "$story_file" "${story_file}.backup"
    
    # Add completion timestamp and documentation verification status
    local completion_note="Task $task_id completed on $(date) with documentation verification"
    
    # Look for Dev Agent Record section or create it
    if ! grep -q "## Dev Agent Record" "$story_file"; then
        echo "" >> "$story_file"
        echo "## Dev Agent Record" >> "$story_file"
        echo "" >> "$story_file"
        echo "### Completion Notes List" >> "$story_file"
        echo "- $completion_note" >> "$story_file"
        echo "" >> "$story_file"
    else
        # Add to existing completion notes
        sed -i.tmp "/### Completion Notes List/a\\
- $completion_note" "$story_file"
        rm -f "${story_file}.tmp"
    fi
    
    # Update File List section if changes were made
    if [ -n "$changes_made" ]; then
        echo "### File List Updates" >> "$story_file"
        echo "Files modified for Task $task_id:" >> "$story_file"
        echo "$changes_made" | tr ',' '\n' | sed 's/^/- /' >> "$story_file"
        echo "" >> "$story_file"
    fi
    
    echo "✅ Story file updated with completion information"
}

# Wrapper for VS Code task integration
vscode_task_wrapper() {
    local task_type="$1"
    shift
    local args="$@"
    
    echo "🔧 VS Code Task: $task_type"
    
    case "$task_type" in
        "analyze")
            enhanced_story_analysis $args
            ;;
        "plan")
            enhanced_implementation_planning $args
            ;;
        "complete")
            integrated_task_completion $args
            ;;
        *)
            echo "❌ Unknown task type: $task_type"
            echo "Available types: analyze, plan, complete"
            return 1
            ;;
    esac
}

# Interactive documentation helper
interactive_documentation_helper() {
    local epic="$1"
    local story="$2"
    local title="$3"
    
    echo "📝 Interactive Documentation Update Helper"
    echo "Story: $epic.$story - $title"
    echo ""
    
    # Check current documentation status
    echo "🔍 Checking current documentation status..."
    echo ""
    
    # Check what files might need documentation updates
    local story_file="docs/stories/$epic.$story.*.md"
    if [ -f "$story_file" ]; then
        echo "📋 Current story file found: $story_file"
    else
        echo "📝 Action required: Story file not found at $story_file"
    fi
    
    # Run documentation detection
    echo ""
    echo "🔍 Running documentation detection..."
    # Call doc-detection script to analyze suggestions for the story context
    bash "$SCRIPT_DIR/doc-detection.sh" --suggest --files "docs/stories/$epic.$story.*.md,templates/vscode/tasks.json,core/scripts/"
    
    echo ""
    echo "📚 Documentation Guidelines for this story:"
    echo ""
    echo "1. ✅ Update user-facing documentation if you've modified:"
    echo "   - README.md (for framework changes)"
    echo "   - VS Code task descriptions or functionality"
    echo "   - CLI interface or commands"
    echo ""
    echo "2. ✅ Update technical documentation if you've modified:"
    echo "   - Core scripts or workflow logic"
    echo "   - Adapter patterns or EmberCare integration"
    echo "   - Configuration options or requirements"
    echo ""
    echo "3. ✅ Update examples if you've modified:"
    echo "   - Template files or task configurations"
    echo "   - Workflow patterns or usage examples"
    echo ""
    echo "📝 Action required: Review the detection results above and update identified documentation files"
    echo ""
    echo "💡 Next steps:"
    echo "1. Use 'Documentation: Check Documentation Requirements' to see specific files"
    echo "2. Update the identified documentation files"
    echo "3. Use 'Documentation: Verify Task Completion' to confirm updates"
}

# Main function handling different workflow integration commands
main() {
    local command="$1"
    shift
    
    case "$command" in
        "analyze")
            enhanced_story_analysis "$@"
            ;;
        "plan")
            enhanced_implementation_planning "$@"
            ;;
        "complete")
            integrated_task_completion "$@"
            ;;
        "help")
            interactive_documentation_helper "$2" "$3" "$4"
            ;;
        "vscode")
            vscode_task_wrapper "$@"
            ;;
        *)
            echo "Usage: $0 <command> [args...]"
            echo ""
            echo "Commands:"
            echo "  analyze <epic> <story> <title> <output-file>     - Enhanced story analysis"
            echo "  plan <epic> <story> <title> <discovery> <plan>   - Enhanced implementation planning"
            echo "  complete <task-id> <story-file> [changes]        - Integrated task completion"
            echo "  help <epic> <story> <title>                      - Interactive documentation helper"
            echo "  vscode <task-type> [args...]                     - VS Code task wrapper"
            echo ""
            echo "Examples:"
            echo "  $0 analyze 1 3 'Documentation Workflow' docs/discovery/story-1-3.md"
            echo "  $0 complete '3.1' 'docs/stories/1.3.md' 'core/scripts/task-completion-verification.sh'"
            return 1
            ;;
    esac
}

# Execute main function if called directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi