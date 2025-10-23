#!/bin/bash

# Quality Assurance Checklist Workflow
# Extracted from BMAD systematic workflows
# Adapted for RAPID-AI direct AI integration

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
CHECKLIST_FILE="${PROJECT_ROOT}/docs/quality-checklist.md"

print_status() {
    local message="$1"
    echo "✅ ${message}"
}

generate_quality_checklist() {
    print_status "Generating quality assurance checklist..."
    
    cat > "${CHECKLIST_FILE}" << 'EOF'
# Development Quality Checklist

## Instructions for Developer

Before marking work as complete, go through each item in this checklist. Mark items as [x] Done, [ ] Not Done, or [N/A] Not Applicable and provide brief comments if necessary.

## Requirements & Functionality

- [ ] All functional requirements are implemented as specified
- [ ] All acceptance criteria are met and verifiable
- [ ] Edge cases and error conditions are handled gracefully
- [ ] Functionality has been manually verified by running/testing the application

**Comments:**

## Code Quality & Standards

- [ ] Code follows established coding standards and conventions
- [ ] Code is well-structured with appropriate separation of concerns
- [ ] Complex logic is documented with clear comments
- [ ] No hardcoded values that should be configurable
- [ ] No obvious security vulnerabilities (input validation, error handling)
- [ ] No new linting errors or warnings introduced

**Comments:**

## Testing

- [ ] Unit tests implemented for new functionality
- [ ] Integration tests added where appropriate
- [ ] All tests pass successfully
- [ ] Test coverage meets project standards
- [ ] Tests cover both happy path and error conditions

**Comments:**

## Build & Dependencies

- [ ] Project builds successfully without errors
- [ ] Linting passes without issues
- [ ] No new dependencies added without justification
- [ ] New dependencies (if any) are documented and secure
- [ ] Environment variables and configurations are documented

**Comments:**

## Documentation

- [ ] Code is self-documenting with clear naming
- [ ] Complex algorithms or business logic are commented
- [ ] User-facing changes are documented (if applicable)
- [ ] README or setup instructions updated (if needed)

**Comments:**

## Integration & Compatibility

- [ ] Changes integrate properly with existing codebase
- [ ] No breaking changes to existing APIs or interfaces
- [ ] Backward compatibility maintained where required
- [ ] Performance impact assessed and acceptable

**Comments:**

## Final Verification

- [ ] All tasks and subtasks are marked complete
- [ ] Implementation decisions are documented
- [ ] Any technical debt or follow-up work is noted
- [ ] Ready for peer review and testing

**Developer Signature:** _______________  **Date:** _______________

**Overall Assessment:**
- [ ] Ready for Review
- [ ] Needs Additional Work (explain below)

**Additional Notes:**

EOF
    
    print_status "Quality checklist created at ${CHECKLIST_FILE}"
}

run_interactive_checklist() {
    print_status "Running interactive quality checklist..."
    
    local temp_checklist="/tmp/rapid-ai-checklist-$(date +%s).md"
    cp "${CHECKLIST_FILE}" "${temp_checklist}"
    
    echo ""
    echo "🔍 Quality Checklist Review"
    echo "==========================="
    echo ""
    echo "Review each section and update the checklist file:"
    echo "  File: ${CHECKLIST_FILE}"
    echo ""
    echo "Mark items as:"
    echo "  [x] Done"
    echo "  [ ] Not Done" 
    echo "  [N/A] Not Applicable"
    echo ""
    echo "Add comments explaining any issues or decisions."
    echo ""
    
    # Open checklist in default editor if available
    if [[ "$TERM_PROGRAM" == "vscode" ]]; then
        code "${CHECKLIST_FILE}"
        echo "📝 Opened checklist in VS Code"
    elif command -v open >/dev/null 2>&1; then
        open "${CHECKLIST_FILE}"
        echo "📝 Opened checklist in default editor"
    else
        echo "📝 Edit checklist manually: ${CHECKLIST_FILE}"
    fi
    
    echo ""
    echo "Press Enter when checklist review is complete..."
    read -r
}

analyze_checklist_completion() {
    print_status "Analyzing checklist completion..."
    
    if [ ! -f "${CHECKLIST_FILE}" ]; then
        echo "❌ Checklist file not found: ${CHECKLIST_FILE}"
        return 1
    fi
    
    local done_count=$(grep -c "\\[x\\]" "${CHECKLIST_FILE}" || echo "0")
    local not_done_count=$(grep -c "\\[ \\]" "${CHECKLIST_FILE}" || echo "0")
    local na_count=$(grep -c "\\[N/A\\]" "${CHECKLIST_FILE}" || echo "0")
    local total_count=$((done_count + not_done_count + na_count))
    
    echo ""
    echo "📊 Checklist Analysis"
    echo "===================="
    echo "✅ Done: ${done_count}"
    echo "❌ Not Done: ${not_done_count}"
    echo "⚪ Not Applicable: ${na_count}"
    echo "📊 Total Items: ${total_count}"
    
    if [ "$total_count" -gt 0 ]; then
        local completion_percentage=$(( (done_count + na_count) * 100 / total_count ))
        echo "📈 Completion: ${completion_percentage}%"
        
        if [ "$not_done_count" -eq 0 ]; then
            echo ""
            echo "🎉 All applicable checklist items completed!"
            return 0
        else
            echo ""
            echo "⚠️  ${not_done_count} items still need attention"
            return 1
        fi
    else
        echo "⚠️  No checklist items found - please update the checklist"
        return 1
    fi
}

main() {
    local mode="${1:-interactive}"
    
    print_status "Starting quality checklist workflow..."
    
    # Ensure docs directory exists
    mkdir -p "${PROJECT_ROOT}/docs"
    
    case "$mode" in
        "generate")
            generate_quality_checklist
            ;;
        "interactive")
            if [ ! -f "${CHECKLIST_FILE}" ]; then
                generate_quality_checklist
            fi
            run_interactive_checklist
            analyze_checklist_completion
            ;;
        "analyze")
            analyze_checklist_completion
            ;;
        *)
            echo "Usage: $0 [generate|interactive|analyze]"
            echo "  generate    - Create new quality checklist"
            echo "  interactive - Run interactive checklist review (default)"
            echo "  analyze     - Analyze existing checklist completion"
            exit 1
            ;;
    esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi