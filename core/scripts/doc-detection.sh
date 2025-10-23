#!/bin/bash

# Documentation Detection and Analysis Script
# Identifies which file changes require documentation updates
# Integrates with RAPID-AI's three-layer architecture
# Based on proven BMAD-METHOD patterns

set -eo pipefail

# AI Configuration for enhanced documentation analysis
ENABLE_AI_ANALYSIS="${ENABLE_AI_ANALYSIS:-false}"
AI_TOOL="${AI_TOOL:-copilot}"  
AI_TIMEOUT="${AI_TIMEOUT:-60}"

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
show_usage() {
    cat << 'EOF'
RAPID-AI Documentation Detection and Analysis

USAGE:
    doc-detection.sh [OPTIONS]

DESCRIPTION:
    Detects when code changes require documentation updates using intelligent
    file pattern matching and optional AI-powered analysis. Integrates with
    VS Code tasks and RAPID-AI workflow automation.

OPTIONS:
    -a, --analyze           Analyze current directory for documentation needs
    -g, --git-diff          Analyze git working directory changes  
    -f, --files FILES       Analyze specific comma-separated files
    -s, --suggest           Generate documentation update suggestions
    --analyze-ai           Run comprehensive AI documentation analysis
    --verify               Verify documentation currency with AI assistance
    -v, --verbose          Enable verbose debug output
    -h, --help             Show this help message

AI INTEGRATION:
    Enable AI analysis: ENABLE_AI_ANALYSIS=true
    Set AI tool: AI_TOOL=copilot (default) or claude/gpt4
    Set timeout: AI_TIMEOUT=60 (seconds)

EXAMPLES:
    $0 --analyze                        # Analyze current directory
    $0 --git-diff                       # Check git changes for doc needs
    $0 --suggest --files "core/ai.sh"   # Get suggestions for specific file
    $0 --analyze-ai                     # Full AI documentation analysis  
    $0 --verify                         # Verify documentation currency
    
    # With AI enabled
    ENABLE_AI_ANALYSIS=true $0 --suggest --files "src/cli.js"
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
    local use_ai="${2:-$ENABLE_AI_ANALYSIS}"
    
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
    
    # AI-Enhanced Documentation Analysis (if enabled)
    if [[ "$use_ai" == "true" ]] && [[ "$ENABLE_AI_ANALYSIS" == "true" ]]; then
        echo "🤖 AI-Enhanced Documentation Analysis:"
        echo "======================================"
        
        if command -v "$AI_TOOL" &> /dev/null; then
            
            # Generate focused AI analysis prompt
            local ai_prompt="Analyze the file '$file_path' for documentation impact.
            
Please provide specific suggestions for documentation updates focusing on:
1. What user-facing changes need documentation
2. What technical changes require documentation updates  
3. What examples or procedures might be affected
4. Specific content suggestions for key documentation files

Be practical and actionable in your recommendations."
            
            local ai_suggestions
            echo "🔄 Generating AI documentation suggestions..."
            
            # Use copilot in programmatic mode without auto-approval to avoid hanging
            if ai_suggestions=$("$AI_TOOL" -p "$ai_prompt" 2>/dev/null); then
                if [[ $? -eq 0 && -n "$ai_suggestions" ]]; then
                    echo "$ai_suggestions"
                    echo
                    echo "💡 Tip: Run with --analyze-ai for comprehensive AI documentation analysis"
                else
                    echo "⚠️ AI analysis unavailable - using pattern-based suggestions only"
                    echo "💡 Enable AI analysis: ENABLE_AI_ANALYSIS=true $0 ..."
                fi
            else
                echo "⚠️ AI analysis failed or was cancelled"
                echo "💡 Try running interactively or check Copilot CLI setup"
            fi
        else
            echo "⚠️ AI tool not available: $AI_TOOL"
            echo "💡 Install GitHub Copilot CLI or set AI_TOOL environment variable"
        fi
        echo
    fi
    
    # Provide actionable next steps
    echo "💡 Next steps:"
    echo "1. Review each file listed above"
    echo "2. Update documentation to reflect changes in $file_path"
    echo "3. Test that examples and instructions still work"
    echo "4. Verify links and references are correct"
    
    if [[ "$use_ai" == "true" ]]; then
        echo "5. Consider AI suggestions for content improvements"
    fi
}

#######################################
# AI-powered comprehensive documentation analysis
# Arguments:
#   $1 - Space-separated list of files to analyze
#   $2 - Output file path (optional)
#######################################
run_ai_documentation_analysis() {
    local target_files="$1"
    local output_file="$2"
    
    echo "🤖 Running comprehensive AI documentation analysis..."
    echo "====================================================="
    
    if [[ "$ENABLE_AI_ANALYSIS" != "true" ]]; then
        echo "⚠️ AI analysis is disabled. Enable with ENABLE_AI_ANALYSIS=true"
        return 1
    fi
    
    if ! command -v "$AI_TOOL" &> /dev/null; then
        echo "❌ AI tool not available: $AI_TOOL"
        echo "💡 Install GitHub Copilot CLI or set AI_TOOL environment variable"
        return 1
    fi
    
    # Generate comprehensive AI prompt for documentation analysis
    local ai_prompt="Perform comprehensive documentation analysis for this project.
    
Files to analyze: $target_files

Please analyze:

1. **Documentation Freshness**
   - Compare documentation against current implementation
   - Identify outdated sections needing updates
   - Rate documentation currency (1-10 scale)

2. **Content Gaps**  
   - Missing documentation for existing features
   - Incomplete sections requiring expansion
   - New functionality lacking documentation

3. **Accuracy Issues**
   - Incorrect procedures or examples
   - Broken links or references
   - Mismatched implementation vs documentation

4. **Improvement Opportunities**
   - Clarity enhancements for better user experience
   - Structural improvements for better organization
   - Additional examples or use cases needed

5. **Priority Recommendations**
   - Critical issues requiring immediate attention
   - Important improvements for next documentation cycle
   - Nice-to-have enhancements for future consideration

Please provide specific, actionable recommendations with file names where possible."
    
    echo "🔄 Generating AI analysis (this may take 30-60 seconds)..."
    
    # Run AI analysis with error handling (no timeout to avoid hanging)
    local ai_output
    
    echo "🔄 Generating AI analysis (this may take 30-60 seconds)..."
    echo "💡 Note: Copilot CLI may require interactive confirmation for trusted directories"
    
    # Run without timeout to avoid hanging issues with Copilot CLI security prompts
    if ai_output=$("$AI_TOOL" -p "$ai_prompt" 2>&1); then
        if [[ $? -eq 0 && -n "$ai_output" ]]; then

            # Prepare output with timestamp
            local timestamp=$(date)
            local report_header="# AI Documentation Analysis Report

**Generated:** $timestamp
**AI Tool:** $AI_TOOL
**Analysis Scope:** $target_files
**RAPID-AI Framework:** Core documentation analysis

---

"

            if [[ -n "$output_file" ]]; then
                # Ensure docs directory exists
                mkdir -p "$(dirname "$output_file")"

                echo "$report_header$ai_output" > "$output_file"
                echo "✅ AI documentation analysis completed: $output_file"

                # Show summary
                echo
                echo "📊 Analysis Summary:"
                echo "==================="
                echo "$ai_output" | head -10
                echo "..."
                echo "(Full analysis saved to $output_file)"
            else
                echo "$report_header$ai_output"
            fi

            return 0
        fi  # Close inner if block
    else
        echo "❌ AI analysis failed or timed out after ${AI_TIMEOUT} seconds"
        echo "💡 Try again with a simpler scope or increase AI_TIMEOUT"
        return 1
    fi
}

#######################################
# Verify documentation currency with AI assistance
# Arguments:
#   $1 - Space-separated list of files to check
#######################################
verify_documentation_currency() {
    local check_files="$1"
    
    echo "🔍 Verifying documentation currency..."
    echo "====================================="
    
    local issues_found=false
    
    # Basic verification using existing patterns
    echo "📋 Pattern-Based Verification:"
    
    if [[ -n "$check_files" ]]; then
        for file in $check_files; do
            if [[ -f "$file" ]]; then
                local docs=$(get_docs_for_pattern "$file")
                if [[ -n "$docs" ]]; then
                    echo "  • $file → requires documentation review"
                    issues_found=true
                fi
            fi
        done
    fi
    
    # Git-based verification
    if command -v git &> /dev/null && git rev-parse --git-dir > /dev/null 2>&1; then
        echo
        echo "📝 Git Change Analysis:"
        
        local recent_changes
        recent_changes=$(git diff --name-only HEAD~1 2>/dev/null || true)
        
        if [[ -n "$recent_changes" ]]; then
            echo "$recent_changes" | while read -r changed_file; do
                if [[ -n "$changed_file" ]] && [[ -f "$changed_file" ]]; then
                    local docs=$(get_docs_for_pattern "$changed_file")
                    if [[ -n "$docs" ]]; then
                        echo "  • $changed_file → may require documentation updates"
                        issues_found=true
                    fi
                fi
            done
        fi
    fi
    
    # AI-enhanced verification (if available)
    if [[ "$ENABLE_AI_ANALYSIS" == "true" ]] && command -v "$AI_TOOL" &> /dev/null; then
        echo
        echo "🤖 AI Currency Verification:"
        
        local verification_prompt="Review recent changes and current documentation to identify any documentation that may be outdated or missing.
        
Recent changes: $check_files
        
Please identify:
1. Documentation that needs immediate updates
2. Missing documentation for new functionality  
3. Outdated examples or procedures
4. Overall documentation health assessment

Be specific about what needs to be updated."
        
        local ai_verification
        
        echo "🔄 Running AI documentation verification..."
        
        # Run without timeout to avoid Copilot CLI hanging on security prompts
        if ai_verification=$("$AI_TOOL" -p "$verification_prompt" 2>/dev/null); then
            if [[ $? -eq 0 && -n "$ai_verification" ]]; then
                echo "$ai_verification" | head -15

                # Check if AI indicates issues
                if echo "$ai_verification" | grep -qi "outdated\|missing\|needs update\|requires"; then
                    issues_found=true
                fi
            fi  # Close inner if block
        else
            echo "⚠️ AI verification unavailable - using pattern-based analysis only"
        fi
    fi
    
    echo
    if [[ "$issues_found" == "true" ]]; then
        echo "⚠️ Documentation verification identified potential issues"
        echo "📋 Review the analysis above and update documentation as needed"
        echo "💡 Run $0 --suggest for specific recommendations"
        return 1
    else
        echo "✅ Documentation appears current with recent changes"
        return 0
    fi
}

#######################################
# Main execution function
#######################################
main() {
    local analyze_mode=false
    local git_diff_mode=false
    local suggest_mode=false
    local ai_analyze_mode=false
    local verify_mode=false
    local files_list=""
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
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
            --analyze-ai)
                ai_analyze_mode=true
                shift
                ;;
            --verify)
                verify_mode=true
                shift
                ;;
            -v|--verbose)
                export VERBOSE=true
                shift
                ;;
            *)
                echo "Unknown option: $1" >&2
                show_usage >&2
                exit 1
                ;;
        esac
    done
    
    log_debug "Starting documentation detection analysis"
    
    # Execute based on mode
    if [[ "$ai_analyze_mode" == "true" ]]; then
        # AI-powered comprehensive analysis
        echo "🤖 AI-Powered Documentation Analysis"
        echo "==================================="
        
        if [[ "$ENABLE_AI_ANALYSIS" != "true" ]]; then
            echo "⚠️ AI analysis is disabled. Enable with: ENABLE_AI_ANALYSIS=true $0 --analyze-ai"
            exit 1
        fi
        
        # Determine files to analyze
        local analysis_files=""
        if [[ -n "$files_list" ]]; then
            analysis_files="$files_list"
        else
            # Auto-detect relevant files
            analysis_files=$(find . -type f \( -name "*.sh" -o -name "*.js" -o -name "*.md" -o -name "*.json" \) | grep -v node_modules | head -20 | tr '\n' ' ')
        fi
        
        # Generate output file
        local output_file="docs/ai-documentation-analysis-$(date +%Y%m%d-%H%M%S).md"
        
        # Run comprehensive AI analysis
        run_ai_documentation_analysis "$analysis_files" "$output_file"
        
    elif [[ "$verify_mode" == "true" ]]; then
        # Documentation currency verification
        local check_files=""
        if [[ -n "$files_list" ]]; then
            check_files="$files_list"
        else
            # Use git changes if available
            if command -v git &> /dev/null && git rev-parse --git-dir > /dev/null 2>&1; then
                check_files=$(git diff --name-only HEAD~1 2>/dev/null | tr '\n' ' ' || true)
            fi
        fi
        
        verify_documentation_currency "$check_files"
        
    elif [[ "$git_diff_mode" == "true" ]]; then
        analyze_git_changes
    elif [[ -n "$files_list" ]]; then
        # Convert comma-separated files to array
        IFS=',' read -ra files_array <<< "$files_list"
        
        if [[ "$suggest_mode" == "true" ]]; then
            for file in "${files_array[@]}"; do
                generate_suggestions "$file" "$ENABLE_AI_ANALYSIS"
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
        echo "Error: Must specify one of --analyze, --git-diff, --files, --analyze-ai, or --verify" >&2
        show_usage >&2
        exit 1
    fi
    
    log_debug "Documentation detection analysis completed"
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi