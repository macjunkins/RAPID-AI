#!/bin/bash

# Common functions for AI development workflow
# Language-agnostic functionality extracted from EmberCare implementation

# Validate script paths and environment
validate_environment() {
    local script_dir="$1"
    local required_files=("$script_dir/../workflows/common-functions.sh")
    
    for file in "${required_files[@]}"; do
        if [ ! -f "$file" ]; then
            echo "❌ Required file not found: $file"
            echo "💡 Please ensure RAPID-AI is properly installed and you're running from the correct directory."
            echo "📋 Expected structure: core/workflows/common-functions.sh should exist"
            return 1
        fi
    done
    
    return 0
}

# Detect environment
detect_environment() {
    if [ "$TERM_PROGRAM" = "vscode" ]; then
        echo "vscode"
    elif [ -n "$CODESPACES" ]; then
        echo "codespaces"
    else
        echo "terminal"
    fi
}

# Progress indicator with environment awareness
show_progress() {
    local duration=${1:-120}
    local environment=$(detect_environment)
    local elapsed=0
    local start_time=$(date +%s)
    
    if [ "$environment" = "vscode" ]; then
        # Enhanced progress for VS Code with elapsed time tracking
        echo "🤖 AI is analyzing... Please wait (timeout: ${duration}s)"
        
        while [ $elapsed -lt $duration ]; do
            if ! kill -0 $AI_PID 2>/dev/null; then
                local end_time=$(date +%s)
                local total_elapsed=$((end_time - start_time))
                echo "✅ Analysis completed in ${total_elapsed} seconds"
                break
            fi
            
            local remaining=$((duration - elapsed))
            echo "⏳ Still processing... (${elapsed}s elapsed, ${remaining}s remaining)"
            sleep 10
            elapsed=$((elapsed + 10))
        done
        
        # Check for timeout
        if [ $elapsed -ge $duration ] && kill -0 $AI_PID 2>/dev/null; then
            echo "⚠️ Analysis is taking longer than expected (${duration}s timeout reached)"
            echo "💡 The process may still complete. Check the output file or try again with a simpler prompt."
        fi
    else
        # Animated progress bar for terminals with enhanced feedback
        local interval=5
        local total_dots=20
        
        echo "🤖 AI is analyzing... (timeout: ${duration}s)"
        
        while [ $elapsed -lt $duration ]; do
            if ! kill -0 $AI_PID 2>/dev/null; then
                local end_time=$(date +%s)
                local total_elapsed=$((end_time - start_time))
                printf "\r✅ Analysis completed in %d seconds\n" "$total_elapsed"
                break
            fi
            
            local progress=$((elapsed * 100 / duration))
            local dots=$((progress * total_dots / 100))
            local bar=""
            local remaining=$((duration - elapsed))
            
            for i in $(seq 1 $total_dots); do
                if [ $i -le $dots ]; then
                    bar="${bar}█"
                else
                    bar="${bar}░"
                fi
            done
            
            printf "\r💭 Progress: [%s] %d%% (%ds remaining)" "$bar" "$progress" "$remaining"
            sleep $interval
            elapsed=$((elapsed + interval))
        done
        
        # Check for timeout
        if [ $elapsed -ge $duration ] && kill -0 $AI_PID 2>/dev/null; then
            printf "\r⚠️ Timeout reached after %d seconds                    \n" "$duration"
            echo "💡 The process may still complete. Check the output file or try again."
        fi
        
        echo "" # Ensure new line after progress
    fi
}

# Check AI tool availability
check_ai_tool_availability() {
    local tool=$1
    
    case "$tool" in
        "copilot")
            if ! command -v copilot &> /dev/null; then
                echo "❌ GitHub Copilot CLI not found"
                echo "💡 To install GitHub Copilot CLI:"
                echo "   1. Visit: https://github.com/github/gh-copilot"
                echo "   2. Install via: gh extension install github/gh-copilot"
                echo "   3. Authenticate: gh auth login"
                echo "   4. Verify: copilot --version"
                return 1
            fi
            
            # Check if copilot is authenticated
            if ! copilot auth status &> /dev/null; then
                echo "❌ GitHub Copilot CLI not authenticated"
                echo "💡 To authenticate GitHub Copilot CLI:"
                echo "   1. Run: gh auth login"
                echo "   2. Follow the authentication prompts"
                echo "   3. Verify: copilot auth status"
                return 1
            fi
            ;;
        "claude")
            echo "⚠️ Claude API integration not yet implemented"
            echo "💡 Available tools: copilot"
            return 1
            ;;
        "gpt4")
            echo "⚠️ OpenAI GPT-4 integration not yet implemented" 
            echo "💡 Available tools: copilot"
            return 1
            ;;
        *)
            echo "❌ Unsupported AI tool: $tool"
            echo "💡 Supported tools: copilot"
            echo "📋 To configure AI tool, update AI_TOOL environment variable or .ai-workflow.yaml"
            return 1
            ;;
    esac
    
    return 0
}

# Run AI analysis with tool abstraction
run_ai_analysis() {
    local tool=$1
    local prompt=$2
    local output_file=$3
    local timeout=${4:-120}
    
    # Check tool availability first
    if ! check_ai_tool_availability "$tool"; then
        echo "🔄 Creating fallback template due to AI tool unavailability..."
        create_fallback_template "$output_file"
        echo "📝 Fallback template created: $output_file"
        return 1
    fi
    
    echo "📊 Generating analysis with $tool..."
    echo "🤖 AI is thinking... (this may take 30-60 seconds)"
    
    # Create temp file for output
    local temp_output=$(mktemp)
    
    # Start progress indicator
    show_progress $timeout &
    local progress_pid=$!
    
    # Run AI tool with timeout
    case "$tool" in
        "copilot")
            timeout ${timeout}s copilot -p "$prompt" > "$temp_output" 2>&1 &
            AI_PID=$!
            ;;
        "claude")
            timeout ${timeout}s claude_api_call "$prompt" > "$temp_output" 2>&1 &
            AI_PID=$!
            ;;
        "gpt4")
            timeout ${timeout}s openai_api_call "$prompt" > "$temp_output" 2>&1 &
            AI_PID=$!
            ;;
        *)
            echo "❌ Unsupported AI tool: $tool"
            kill $progress_pid 2>/dev/null || true
            rm -f "$temp_output"
            return 1
            ;;
    esac
    
    # Wait for completion
    wait $AI_PID
    local exit_code=$?
    
    # Stop progress indicator
    kill $progress_pid 2>/dev/null || true
    wait $progress_pid 2>/dev/null || true
    
    if [ $exit_code -eq 0 ] && [ -s "$temp_output" ]; then
        # Success - process output
        process_ai_output "$temp_output" "$output_file"
        echo "✅ Analysis complete: $output_file"
    elif [ $exit_code -eq 124 ]; then
        # Timeout
        echo "⚠️ AI analysis timed out after ${timeout} seconds"
        echo "💡 Try again with a simpler prompt or increase timeout (AI_TIMEOUT environment variable)"
        echo "🔄 Creating fallback template..."
        create_fallback_template "$output_file"
        echo "📝 Fallback template created: $output_file"
    else
        # Other failure
        echo "⚠️ AI analysis failed (exit code: $exit_code)"
        if [ -s "$temp_output" ]; then
            echo "📋 Error details:"
            head -n 5 "$temp_output" | sed 's/^/   /'
        fi
        echo "🔄 Creating fallback template..."
        create_fallback_template "$output_file"
        echo "📝 Fallback template created: $output_file"
    fi
    
    # Cleanup
    rm -f "$temp_output"
    
    # Auto-open in editor if available
    auto_open_file "$output_file"
    
    return $exit_code
}

# Process AI output and add metadata
process_ai_output() {
    local temp_file=$1
    local output_file=$2
    
    # Add metadata header
    cat > "$output_file" << EOF
# Story Discovery - AI Generated

**Generated by:** AI Development Workflow
**Date:** $(date +%Y-%m-%d)
**AI Tool:** $AI_TOOL
**Status:** AI Analysis Complete

---

EOF
    
    # Append AI content
    cat "$temp_file" >> "$output_file"
}

# Create fallback template when AI fails
create_fallback_template() {
    local output_file=$1
    
    cat > "$output_file" << EOF
# Story Discovery - Template

**Generated by:** AI Development Workflow (Fallback Template)
**Date:** $(date +%Y-%m-%d)
**Status:** Manual completion required

---

## Story Summary
[Add story details from requirements]

## Technical Analysis
### Requirements
- [ ] Review functional requirements
- [ ] Identify non-functional requirements
- [ ] Define acceptance criteria

### Architecture Considerations
- [ ] Database changes needed
- [ ] API changes required
- [ ] UI components to build
- [ ] Integration points

### Implementation Plan
1. [ ] Step 1: [Define specific step]
2. [ ] Step 2: [Define specific step]
3. [ ] Step 3: [Define specific step]

### Testing Strategy
- [ ] Unit tests required
- [ ] Integration tests needed
- [ ] E2E testing approach

### Files to Create/Modify
- [ ] \`file1.ext\` - [Purpose]
- [ ] \`file2.ext\` - [Purpose]

## Next Steps
1. Complete the manual analysis above
2. Review with team
3. Begin implementation

---
*This template was created because AI analysis failed or timed out. Please complete manually.*
EOF
}

# Auto-open file in appropriate editor
auto_open_file() {
    local file=$1
    local environment=$(detect_environment)
    
    case "$environment" in
        "vscode")
            if command -v code &> /dev/null; then
                echo "📂 Opening in VS Code..."
                code "$file"
            fi
            ;;
        "codespaces")
            echo "📂 File ready: $file"
            ;;
        *)
            if command -v code &> /dev/null; then
                echo "📂 Opening in VS Code..."
                code "$file"
            elif command -v open &> /dev/null; then
                echo "📂 Opening file..."
                open "$file"
            fi
            ;;
    esac
}

# Post-process discovery document
post_process_discovery() {
    local file=$1
    
    # Add any post-processing logic here
    # For example: validate structure, add links, etc.
    
    echo "📝 Discovery document ready: $file"
}

# API calls for different AI tools (placeholder implementations)
claude_api_call() {
    local prompt=$1
    # TODO: Implement Claude API integration
    echo "Claude API integration not yet implemented"
    return 1
}

openai_api_call() {
    local prompt=$1
    # TODO: Implement OpenAI API integration
    echo "OpenAI API integration not yet implemented"
    return 1
}

# Load project configuration
load_project_config() {
    if [ -f "$PROJECT_CONFIG" ]; then
        # Load project-specific settings (requires yq for YAML parsing)
        if command -v yq &> /dev/null; then
            PROJECT_TYPE=$(yq eval '.project.type' "$PROJECT_CONFIG" 2>/dev/null || echo "generic")
            AI_TOOL=$(yq eval '.ai_tools[0]' "$PROJECT_CONFIG" 2>/dev/null || echo "$AI_TOOL")
            ARCHITECTURE=$(yq eval '.project.architecture[]' "$PROJECT_CONFIG" 2>/dev/null || echo "")
        else
            # Fallback to basic parsing without yq
            PROJECT_TYPE=$(grep "type:" "$PROJECT_CONFIG" | sed 's/.*type: *"\?\([^"]*\)"\?.*/\1/' || echo "generic")
        fi
    else
        PROJECT_TYPE="generic"
        ARCHITECTURE=""
    fi
}

# Generate AI prompt based on project type
generate_prompt() {
    local epic=$1
    local story=$2
    local title=$3
    local base_prompt="Analyze Epic $epic, Story $story: $title"
    
    case "$PROJECT_TYPE" in
        "flutter")
            echo "$base_prompt. For this Flutter project using BLoC + Drift architecture, provide: 1. Story requirements summary 2. Drift table definitions 3. BLoC events/states 4. UI components 5. Testing approach 6. Implementation files list. Keep response concise and actionable."
            ;;
        "react")
            echo "$base_prompt. For this React project, provide: 1. Component requirements 2. State management approach 3. API integrations 4. Testing strategy 5. Implementation files list."
            ;;
        "python")
            echo "$base_prompt. For this Python project, provide: 1. Requirements analysis 2. Database models 3. API endpoints 4. Testing approach 5. Implementation files list."
            ;;
        *)
            echo "$base_prompt. Provide: 1. Requirements summary 2. Technical approach 3. Implementation plan 4. Testing strategy 5. Files to create/modify."
            ;;
    esac
}

# Documentation Detection Functions
# Based on proven BMAD-METHOD patterns, adapted for RAPID-AI

# Check if file changes require documentation updates
check_documentation_needs() {
    local changed_files="$1"
    
    if [ -z "$changed_files" ]; then
        return 1
    fi
    
    # Use the documentation detection script
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local doc_detection_script="$script_dir/../scripts/doc-detection.sh"
    
    if [ -f "$doc_detection_script" ]; then
        echo "$changed_files" | tr ',' '\n' | while read -r file; do
            if [ -n "$file" ]; then
                "$doc_detection_script" -f "$file" --suggest
            fi
        done
    else
        echo "⚠️ Documentation detection script not found: $doc_detection_script"
        return 1
    fi
}

# Get documentation files that need updating for a specific file
get_documentation_files() {
    local file_path="$1"
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local doc_detection_script="$script_dir/../scripts/doc-detection.sh"
    
    if [ -f "$doc_detection_script" ]; then
        "$doc_detection_script" -f "$file_path" 2>/dev/null | grep "^•" | sed 's/^• //'
    fi
}

# Validate documentation currency (basic implementation)
validate_documentation_currency() {
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local doc_detection_script="$script_dir/../scripts/doc-detection.sh"
    
    echo "🔍 Checking documentation currency..."
    
    if [ -f "$doc_detection_script" ]; then
        # Check git changes for documentation needs
        "$doc_detection_script" --git-diff
        return $?
    else
        echo "⚠️ Documentation detection not available"
        return 1
    fi
}

# Generate documentation update suggestions
suggest_documentation_updates() {
    local changed_files="$1"
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local doc_detection_script="$script_dir/../scripts/doc-detection.sh"
    
    if [ -f "$doc_detection_script" ] && [ -n "$changed_files" ]; then
        echo "💡 Documentation update suggestions:"
        echo "$changed_files" | tr ',' '\n' | while read -r file; do
            if [ -n "$file" ]; then
                "$doc_detection_script" -f "$file" --suggest
            fi
        done
    fi
}