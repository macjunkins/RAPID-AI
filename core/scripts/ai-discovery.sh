#!/bin/bash

#!/bin/bash

# AI-powered story discovery and analysis
# Integrates with multiple AI tools for systematic story analysis
# Now includes documentation detection and analysis

set -euo pipefail
# Language-agnostic core extracted from EmberCare implementation

set -e

# Configuration
PROJECT_CONFIG="${PROJECT_CONFIG:-.ai-workflow.yaml}"
AI_TOOL="${AI_TOOL:-copilot}"
TIMEOUT="${TIMEOUT:-120}"

# Import framework functions
SCRIPT_DIR="$(dirname "$0")"

# Validate environment before proceeding
if ! source "$SCRIPT_DIR/../workflows/common-functions.sh" 2>/dev/null; then
    echo "❌ Cannot load common functions from: $SCRIPT_DIR/../workflows/common-functions.sh"
    echo "💡 Please ensure you're running RAPID-AI from the correct directory structure."
    echo "📋 Expected: core/scripts/ and core/workflows/ directories should exist"
    exit 1
fi

# Validate environment
if ! validate_environment "$SCRIPT_DIR"; then
    exit 1
fi

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