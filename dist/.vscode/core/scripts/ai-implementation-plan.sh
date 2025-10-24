#!/bin/bash

# AI-powered implementation planning (framework version)
# Extracted from EmberCare copilot-implementation-plan.sh
# Enhanced with documentation verification integration

set -e

# Configuration
PROJECT_CONFIG="${PROJECT_CONFIG:-.ai-workflow.yaml}"
AI_TOOL="${AI_TOOL:-copilot}"
TIMEOUT="${TIMEOUT:-120}"

# Import framework functions
SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/../workflows/common-functions.sh"

# Parse arguments
EPIC=$1
STORY=$2
TITLE=$3
DISCOVERY_FILE=$4
OUTPUT_FILE=$5

# Validate inputs
validate_inputs() {
    if [ -z "$EPIC" ] || [ -z "$STORY" ] || [ -z "$TITLE" ] || [ -z "$OUTPUT_FILE" ]; then
        echo "Usage: $0 <epic> <story> <title> [discovery-file] <output-file>"
        echo "Example: $0 1 4 'User Authentication' docs/discovery/story-1-4.md docs/plans/story-1-4-plan.md"
        exit 1
    fi
}

# Generate implementation planning prompt
generate_planning_prompt() {
    local epic=$1
    local story=$2
    local title=$3
    local discovery_file=$4
    
    local base_prompt="Create detailed implementation plan for Epic $epic, Story $story: $title"
    
    if [ -n "$discovery_file" ] && [ -f "$discovery_file" ]; then
        base_prompt="$base_prompt. Use the discovery document at $discovery_file as context."
    fi
    
    case "$PROJECT_TYPE" in
        "flutter")
            echo "$base_prompt. For this Flutter project, provide: 1. Step-by-step implementation plan 2. File structure with specific paths 3. BLoC events/states implementation 4. Drift database changes 5. UI component hierarchy 6. Testing checklist 7. Dependencies to add. Format as actionable implementation guide."
            ;;
        "react")
            echo "$base_prompt. For this React project, provide: 1. Implementation steps 2. Component structure 3. State management setup 4. API integration 5. Testing plan 6. File organization."
            ;;
        "python")
            echo "$base_prompt. For this Python project, provide: 1. Implementation steps 2. Model definitions 3. API endpoints 4. Database migrations 5. Testing approach 6. File structure."
            ;;
        *)
            echo "$base_prompt. Provide: 1. Step-by-step implementation plan 2. File structure 3. Key technical decisions 4. Testing approach 5. Dependencies needed."
            ;;
    esac
}

# Post-process implementation plan
post_process_plan() {
    local file=$1
    
    # Add implementation-specific footer
    cat >> "$file" << 'EOF'

---

## Implementation Notes

### Before Starting
- [ ] Review discovery document for context
- [ ] Ensure development environment is set up
- [ ] Create feature branch for implementation
- [ ] Review acceptance criteria with team

### During Implementation
- [ ] Follow test-driven development approach
- [ ] Commit frequently with meaningful messages
- [ ] Update documentation as you build
- [ ] Review code with team members

### Documentation Verification (Required for Task Completion)
- [ ] Run documentation currency check: ./core/scripts/task-completion-check.sh
- [ ] Update any outdated documentation files
- [ ] Verify all user-facing changes are documented
- [ ] Confirm documentation is consistent with implementation

### After Implementation
- [ ] Run full test suite
- [ ] Update any affected documentation
- [ ] Verify documentation verification checklist is complete
- [ ] Create pull request with detailed description
- [ ] Demo functionality to stakeholders

EOF

    echo "📋 Implementation plan ready: $file"
    echo "💡 Remember to run documentation verification before marking tasks complete:"
    echo "   ./core/scripts/task-completion-check.sh [changed-files]"
}

# Main execution
main() {
    validate_inputs
    load_project_config
    
    echo "📋 Creating implementation plan for Story $EPIC.$STORY: $TITLE"
    echo "📊 Project type: $PROJECT_TYPE | AI tool: $AI_TOOL"
    
    local prompt=$(generate_planning_prompt "$EPIC" "$STORY" "$TITLE" "$DISCOVERY_FILE")
    local output_dir=$(dirname "$OUTPUT_FILE")
    
    # Ensure output directory exists
    mkdir -p "$output_dir"
    
    # Run AI analysis with timeout protection
    run_ai_analysis "$AI_TOOL" "$prompt" "$OUTPUT_FILE" "$TIMEOUT"
    
    # Post-process results
    post_process_plan "$OUTPUT_FILE"
    
    # Check for documentation needs after implementation planning
    echo "🔍 Checking documentation requirements for implementation plan..."
    local docs_needed=$(check_documentation_needs "")
    if [ $? -eq 0 ] && [ -n "$docs_needed" ]; then
        echo "📝 Documentation update suggestions available"
        suggest_documentation_updates ""
    fi
    
    echo "✅ Implementation plan generated: $OUTPUT_FILE"
}

# Check if script is being called directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi