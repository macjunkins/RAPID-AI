#!/bin/bash

# AI-powered story/feature discovery (framework version)
# Language-agnostic core extracted from EmberCare implementation

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
OUTPUT_FILE=$4

# Validate inputs
validate_inputs() {
    if [ -z "$EPIC" ] || [ -z "$STORY" ] || [ -z "$TITLE" ] || [ -z "$OUTPUT_FILE" ]; then
        echo "Usage: $0 <epic> <story> <title> <output-file>"
        echo "Example: $0 1 4 'User Authentication' docs/discovery/story-1-4-discovery.md"
        exit 1
    fi
}

# Main execution
main() {
    validate_inputs
    load_project_config
    
    echo "🤖 Running AI analysis for Story $EPIC.$STORY: $TITLE"
    echo "📊 Project type: $PROJECT_TYPE | AI tool: $AI_TOOL"
    
    local prompt=$(generate_prompt "$EPIC" "$STORY" "$TITLE")
    local output_dir=$(dirname "$OUTPUT_FILE")
    
    # Ensure output directory exists
    mkdir -p "$output_dir"
    
    # Run AI analysis with timeout protection
    run_ai_analysis "$AI_TOOL" "$prompt" "$OUTPUT_FILE" "$TIMEOUT"
    
    # Post-process results
    post_process_discovery "$OUTPUT_FILE"
    
    echo "✅ Discovery document generated: $OUTPUT_FILE"
}

# Check if script is being called directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi