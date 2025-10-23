#!/bin/bash

# Documentation Detection and Analysis Script
# Identifies which file changes require documentation updates
# Integrates with RAPID-AI's three-layer architecture
# Based on proven BMAD-METHOD patterns

set -eo pipefail

# Source common functions if available
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMON_FUNCTIONS="${SCRIPT_DIR}/../workflows/common-functions.sh"

if [ -f "$COMMON_FUNCTIONS" ]; then
    source "$COMMON_FUNCTIONS"
fi

# Configuration
DOC_DETECTION_CONFIG=".ai-workflow.yaml"
DEBUG_LOG=".ai/debug-log.md"

# Documentation mapping configuration (using simple functions instead of associative arrays)
# This approach ensures compatibility with older bash versions

# Check if file matches a pattern and return corresponding docs
get_docs_for_pattern() {
    local file_path="$1"
    
    case "$file_path" in
        core/scripts/*)
            echo "README.md,docs/architecture/source-tree-and-module-organization.md"
            ;;
        core/workflows/*)
            echo "README.md,docs/architecture/high-level-architecture.md"
            ;;
        adapters/*)
            echo "README.md,docs/architecture/source-tree-and-module-organization.md"
            ;;
        templates/vscode/*)
            echo "README.md,templates/vscode/README.md"
            ;;
        src/*)
            echo "README.md,docs/architecture/source-tree-and-module-organization.md"
            ;;
        .ai-workflow.yaml)
            echo "README.md,examples/embercare/README.md"
            ;;
        docs/architecture/*)
            echo "docs/architecture/index.md"
            ;;
        docs/prd/*)
            echo "docs/prd/index.md"
            ;;
        *)
            echo ""
            ;;
    esac
}

#######################################
# Display usage information
#######################################
usage() {
    cat << EOF
Usage: $0 [OPTIONS] [FILE_PATH...]

Documentation Detection and Analysis for RAPID-AI

OPTIONS:
    -h, --help          Show this help message
    -a, --analyze       Analyze current working directory for documentation needs
    -f, --files FILES   Comma-separated list of changed files to analyze
    -g, --git-diff      Analyze files changed in git working directory
    -s, --suggest       Suggest documentation updates based on analysis
    -v, --verbose       Enable verbose output
    
EXAMPLES:
    $0 --analyze                    # Analyze current directory
    $0 --git-diff                   # Analyze git changes
    $0 -f "core/scripts/ai.sh,src/cli.js"  # Analyze specific files
    $0 --suggest --files "adapters/flutter/scripts/new.sh"  # Get suggestions

EOF
}

#######################################
# Log debug information
#######################################
log_debug() {
    local message="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    if [[ "${VERBOSE:-false}" == "true" ]]; then
        echo "DEBUG: $message" >&2
    fi
    
    # Append to debug log if it exists
    if [[ -f "$DEBUG_LOG" ]]; then
        echo "[$timestamp] DOC-DETECTION: $message" >> "$DEBUG_LOG"
    fi
}

#######################################
# Detect if file changes require documentation updates
# Arguments:
#   $1 - File path to analyze
# Returns:
#   0 if documentation update needed, 1 otherwise
#######################################
needs_documentation_update() {
    local file_path="$1"
    
    log_debug "Analyzing file: $file_path"
    
    # Check if file matches any documentation pattern
    local docs=$(get_docs_for_pattern "$file_path")
    if [[ -n "$docs" ]]; then
        log_debug "File $file_path requires documentation updates"
        return 0
    fi
    
    # Check for user-facing feature patterns
    if is_user_facing_change "$file_path"; then
        log_debug "File $file_path contains user-facing changes"
        return 0
    fi
    
    return 1
}

#######################################
# Determine if file contains user-facing changes
# Arguments:
#   $1 - File path to analyze
# Returns:
#   0 if user-facing, 1 otherwise
#######################################
is_user_facing_change() {
    local file_path="$1"
    
    # Check file patterns that indicate user-facing changes
    case "$file_path" in
        templates/vscode/*)
            log_debug "VS Code task change detected"
            return 0
            ;;
        src/cli.js)
            log_debug "CLI interface change detected"
            return 0
            ;;
        adapters/*/scripts/*)
            log_debug "Adapter script change detected"
            return 0
            ;;
        core/scripts/*)
            log_debug "Core script change detected"
            return 0
            ;;
        .ai-workflow.yaml)
            log_debug "Configuration change detected"
            return 0
            ;;
        README.md)
            log_debug "Main documentation change detected"
            return 0
            ;;
    esac
    
    return 1
}

#######################################
# Get list of documentation files that need updating
# Arguments:
#   $1 - File path that changed
# Output:
#   Newline-separated list of documentation files
#######################################
get_docs_to_update() {
    local file_path="$1"
    
    log_debug "Getting documentation files for: $file_path"
    
    # Get documentation mapping for this file
    local docs_list=$(get_docs_for_pattern "$file_path")
    
    if [[ -n "$docs_list" ]]; then
        # Convert comma-separated to newline-separated
        echo "$docs_list" | tr ',' '\n'
        log_debug "Mapped to docs: $docs_list"
    fi
}

#######################################
# Analyze git working directory for changes
# Output:
#   Analysis results
#######################################
analyze_git_changes() {
    log_debug "Analyzing git working directory changes"
    
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "Error: Not in a git repository" >&2
        return 1
    fi
    
    # Get list of changed files
    local changed_files
    changed_files=$(git diff --name-only HEAD 2>/dev/null || true)
    
    if [[ -z "$changed_files" ]]; then
        echo "No files changed in working directory"
        return 0
    fi
    
    echo "=== Git Working Directory Analysis ==="
    echo
    
    while IFS= read -r file; do
        if [[ -n "$file" ]] && needs_documentation_update "$file"; then
            echo "📝 File requiring documentation update: $file"
            local docs_to_update
            docs_to_update=$(get_docs_to_update "$file")
            if [[ -n "$docs_to_update" ]]; then
                echo "   → Documentation files to review:"
                echo "$docs_to_update" | sed 's/^/     • /'
                echo
            fi
        fi
    done <<< "$changed_files"
}

#######################################
# Analyze specific files
# Arguments:
#   $@ - List of files to analyze
#######################################
analyze_files() {
    local files=("$@")
    
    echo "=== File Analysis Results ==="
    echo
    
    for file in "${files[@]}"; do
        if [[ -n "$file" ]]; then
            echo "📁 Analyzing: $file"
            
            if needs_documentation_update "$file"; then
                echo "   ✅ Requires documentation update"
                
                local docs_to_update
                docs_to_update=$(get_docs_to_update "$file")
                if [[ -n "$docs_to_update" ]]; then
                    echo "   📄 Documentation files to review:"
                    echo "$docs_to_update" | sed 's/^/     • /'
                fi
            else
                echo "   ⏭️  No documentation update needed"
            fi
            echo
        fi
    done
}

#######################################
# Generate documentation update suggestions
# Arguments:
#   $1 - File path that changed
#######################################
generate_suggestions() {
    local file_path="$1"
    
    echo "=== Documentation Update Suggestions ==="
    echo
    echo "📁 Changed file: $file_path"
    echo
    
    if ! needs_documentation_update "$file_path"; then
        echo "ℹ️  This file change doesn't require documentation updates"
        return 0
    fi
    
    local docs_to_update
    docs_to_update=$(get_docs_to_update "$file_path")
    
    echo "📝 Documentation files to review and update:"
    echo
    
    while IFS= read -r doc_file; do
        if [[ -n "$doc_file" ]]; then
            # Format for VS Code problem matcher integration
            echo "📋 Documentation required for: $doc_file"
            echo "• $doc_file"
            
            # Provide specific suggestions based on file type
            case "$doc_file" in
                README.md)
                    echo "  → Update installation, usage, or feature descriptions"
                    ;;
                docs/architecture/*)
                    echo "  → Update architecture diagrams and technical details"
                    ;;
                docs/*)
                    echo "  → Update technical documentation and examples"
                    ;;
                examples/*)
                    echo "  → Update usage examples and integration guides"
                    ;;
                *)
                    echo "  → Review and update as needed"
                    ;;
            esac
            echo
        fi
    done <<< "$docs_to_update"
    
    # Provide actionable next steps
    echo "💡 Next steps:"
    echo "1. Review each file listed above"
    echo "2. Update documentation to reflect changes in $file_path"
    echo "3. Test that examples and instructions still work"
    echo "4. Verify links and references are correct"
}

#######################################
# Main execution function
#######################################
main() {
    local analyze_mode=false
    local git_diff_mode=false
    local suggest_mode=false
    local files_list=""
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                usage
                exit 0
                ;;
            -a|--analyze)
                analyze_mode=true
                shift
                ;;
            -g|--git-diff)
                git_diff_mode=true
                shift
                ;;
            -f|--files)
                files_list="$2"
                shift 2
                ;;
            -s|--suggest)
                suggest_mode=true
                shift
                ;;
            -v|--verbose)
                export VERBOSE=true
                shift
                ;;
            *)
                echo "Unknown option: $1" >&2
                usage >&2
                exit 1
                ;;
        esac
    done
    
    log_debug "Starting documentation detection analysis"
    
    # Execute based on mode
    if [[ "$git_diff_mode" == "true" ]]; then
        analyze_git_changes
    elif [[ -n "$files_list" ]]; then
        # Convert comma-separated files to array
        IFS=',' read -ra files_array <<< "$files_list"
        
        if [[ "$suggest_mode" == "true" ]]; then
            for file in "${files_array[@]}"; do
                generate_suggestions "$file"
            done
        else
            analyze_files "${files_array[@]}"
        fi
    elif [[ "$analyze_mode" == "true" ]]; then
        echo "=== Current Directory Analysis ==="
        echo "Analyzing current working directory for documentation needs..."
        echo
        
        # Find recently modified files
        local recent_files
        recent_files=$(find . -type f -name "*.sh" -o -name "*.js" -o -name "*.json" -o -name "*.yaml" -o -name "*.md" | head -20)
        
        if [[ -n "$recent_files" ]]; then
            analyze_files $recent_files
        else
            echo "No relevant files found in current directory"
        fi
    else
        echo "Error: Must specify one of --analyze, --git-diff, or --files" >&2
        usage >&2
        exit 1
    fi
    
    log_debug "Documentation detection analysis completed"
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi