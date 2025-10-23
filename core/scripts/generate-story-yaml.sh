#!/bin/bash

# Generate Story YAML from Epic Context
# Uses Claude CLI to generate structured story YAML from epic context
# Story 1.1: Generate Story YAML from Epic Context

set -e  # Exit on error

# Get script directory for relative paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Source common functions
source "$SCRIPT_DIR/../workflows/common-functions.sh"

# Parse arguments
EPIC_ID="$1"
STORY_ID="$2"
STORY_TITLE="$3"

# Validate arguments
if [ -z "$EPIC_ID" ] || [ -z "$STORY_ID" ] || [ -z "$STORY_TITLE" ]; then
    echo "❌ Missing required arguments"
    echo ""
    echo "Usage: generate-story-yaml.sh <epic_id> <story_id> <story_title>"
    echo ""
    echo "Example:"
    echo "  generate-story-yaml.sh 1 2 'Define Story YAML Schema'"
    echo ""
    exit 1
fi

# Define paths
EPIC_FILE="$PROJECT_ROOT/docs/prd/epic-$EPIC_ID.yaml"
STORY_FILE="$PROJECT_ROOT/docs/stories/$EPIC_ID-$STORY_ID-story.yaml"
PROMPT_TEMPLATE="$SCRIPT_DIR/../prompts/story-generation-prompt.txt"

echo "🚀 RAPID-AI Story Generator"
echo "============================"
echo ""
echo "📋 Configuration:"
echo "  Epic ID: $EPIC_ID"
echo "  Story ID: $STORY_ID"
echo "  Story Title: $STORY_TITLE"
echo "  Epic File: $EPIC_FILE"
echo "  Output File: $STORY_FILE"
echo ""

# Check if epic file exists
if [ ! -f "$EPIC_FILE" ]; then
    echo "❌ Epic file not found: $EPIC_FILE"
    echo ""
    echo "Available epic files:"
    ls -1 "$PROJECT_ROOT/docs/prd/"epic-*.yaml 2>/dev/null || echo "  (none found)"
    echo ""
    echo "💡 Create the epic file first using:"
    echo "   - Copy docs/prd/epic-1.yaml as template"
    echo "   - Or generate epic YAML (coming in future story)"
    echo ""
    exit 1
fi

# Check if Claude CLI is available
if ! command -v claude &> /dev/null; then
    echo "❌ Claude CLI not found"
    echo ""
    echo "💡 Claude CLI is required for story generation"
    echo ""
    echo "Installation:"
    echo "  1. Ensure you have Claude subscription"
    echo "  2. Claude CLI should be available via 'claude' command"
    echo "  3. Verify: claude --version"
    echo ""
    echo "Documentation: https://docs.claude.com/en/docs/claude-code"
    echo ""
    exit 1
fi

# Check if yq is available for YAML validation
if ! command -v yq &> /dev/null; then
    echo "⚠️  yq not found - YAML validation will be skipped"
    echo "💡 Install yq for YAML validation: brew install yq"
    echo ""
fi

# Read epic context
echo "📖 Reading epic context..."
EPIC_CONTEXT=$(cat "$EPIC_FILE")

echo "✅ Epic context loaded ($(echo "$EPIC_CONTEXT" | wc -l) lines)"
echo ""

# Build Claude prompt
echo "🤖 Building Claude prompt..."

# Create prompt with epic context and schema
PROMPT=$(cat <<EOF
You are a story specification generator for the RAPID-AI framework.

CONTEXT - Epic Information:
\`\`\`yaml
$EPIC_CONTEXT
\`\`\`

TASK:
Generate a structured story YAML file for:
- Epic ID: $EPIC_ID
- Story ID: $STORY_ID
- Story Title: $STORY_TITLE

REQUIREMENTS:
1. The story must be contextually relevant to the epic above
2. Output VALID YAML only - no markdown fences, no explanation text
3. Follow the exact schema structure defined below
4. Include all required fields
5. Be specific and actionable in all descriptions

STORY YAML SCHEMA:
\`\`\`yaml
story:
  id: "string (e.g., '1.2')"
  epic_id: number
  title: "string"
  priority: "string (critical|high|medium|low)"
  status: "string (planned|in_progress|completed)"
  created: "date (YYYY-MM-DD)"
  updated: "date (YYYY-MM-DD)"

  metadata:
    estimated_effort: "string (e.g., '2-3 hours')"
    actual_effort: null
    assigned_to: "string"
    tags: ["array", "of", "strings"]

  rationale: |
    Multi-line string explaining WHY this story matters
    and what value it provides

  description: |
    Multi-line string with detailed story description.
    Include user workflow, technical approach, expected outcomes.

  acceptance_criteria:
    - criteria: "String describing what must be true"
      validation: "How to verify this criteria is met"
    - criteria: "Another criteria"
      validation: "Validation approach"

  technical_notes:
    key_technical_area: |
      Technical details, constraints, implementation notes
    another_area: |
      More technical guidance

  implementation_files:
    create:
      - path: "relative/path/to/new/file.ext"
        purpose: "Why this file is needed"
        details: |
          Additional implementation details
    modify:
      - path: "relative/path/to/existing/file.ext"
        changes: |
          What changes are needed

  testing_approach:
    manual_tests:
      - test: "Test name"
        steps:
          - "Step 1"
          - "Step 2"
        expected: "Expected outcome"

    success_validation:
      - "Validation point 1"
      - "Validation point 2"

  dependencies:
    required:
      - dependency: "What is required"
        validation: "How to verify it exists"
        installation: "How to install if missing"

  completion_criteria:
    - "Criteria 1 for story completion"
    - "Criteria 2 for story completion"
\`\`\`

IMPORTANT OUTPUT REQUIREMENTS:
- Output ONLY valid YAML
- Do NOT wrap output in markdown code fences
- Do NOT include any explanatory text before or after the YAML
- The first line should start with "story:"
- All multi-line strings should use the | or > YAML syntax
- Ensure proper indentation (2 spaces per level)

Generate the story YAML now for: $STORY_TITLE
EOF
)

echo "✅ Prompt built ($(echo "$PROMPT" | wc -l) lines)"
echo ""

# Call Claude CLI
echo "🤖 Calling Claude CLI to generate story..."
echo "⏱️  This typically takes 10-30 seconds..."
echo ""

# Create temp file for Claude output
TEMP_OUTPUT=$(mktemp)

# Call Claude with timeout
if timeout 60s claude -p "$PROMPT" > "$TEMP_OUTPUT" 2>&1; then
    echo "✅ Claude CLI completed successfully"
    echo ""
else
    EXIT_CODE=$?
    echo "❌ Claude CLI failed (exit code: $EXIT_CODE)"
    echo ""

    if [ $EXIT_CODE -eq 124 ]; then
        echo "⏱️  Timeout: Claude CLI took longer than 60 seconds"
        echo "💡 Try again - API might be slow"
    else
        echo "📋 Error output:"
        head -n 10 "$TEMP_OUTPUT" | sed 's/^/   /'
    fi

    rm -f "$TEMP_OUTPUT"
    exit 1
fi

# Check if output is non-empty
if [ ! -s "$TEMP_OUTPUT" ]; then
    echo "❌ Claude CLI returned empty output"
    rm -f "$TEMP_OUTPUT"
    exit 1
fi

# Clean up output (remove markdown fences if present)
echo "🧹 Cleaning output..."

# Remove markdown code fences if present
sed -i.bak '/^```yaml$/d; /^```$/d' "$TEMP_OUTPUT"
rm -f "$TEMP_OUTPUT.bak"

# Validate YAML if yq is available
if command -v yq &> /dev/null; then
    echo "✅ Validating YAML structure..."

    if yq eval . "$TEMP_OUTPUT" > /dev/null 2>&1; then
        echo "✅ YAML is valid"
    else
        echo "❌ Generated YAML is invalid"
        echo ""
        echo "📋 YAML validation errors:"
        yq eval . "$TEMP_OUTPUT" 2>&1 | sed 's/^/   /'
        echo ""
        echo "💡 Claude might have generated invalid YAML. Saving anyway for manual review."
    fi
    echo ""
fi

# Create output directory if it doesn't exist
mkdir -p "$(dirname "$STORY_FILE")"

# Save to output file
cp "$TEMP_OUTPUT" "$STORY_FILE"
rm -f "$TEMP_OUTPUT"

echo "✅ Story YAML saved to: $STORY_FILE"
echo ""

# Show summary
echo "📊 Summary:"
echo "  Story: $EPIC_ID.$STORY_ID - $STORY_TITLE"
echo "  File: $STORY_FILE"
echo "  Size: $(wc -l < "$STORY_FILE") lines"
echo ""

# Validate required fields
echo "🔍 Validating required fields..."

REQUIRED_FIELDS=("story.id" "story.title" "story.description" "story.acceptance_criteria")
MISSING_FIELDS=()

for field in "${REQUIRED_FIELDS[@]}"; do
    if command -v yq &> /dev/null; then
        if ! yq eval ".$field" "$STORY_FILE" > /dev/null 2>&1; then
            MISSING_FIELDS+=("$field")
        fi
    fi
done

if [ ${#MISSING_FIELDS[@]} -gt 0 ]; then
    echo "⚠️  Missing required fields:"
    for field in "${MISSING_FIELDS[@]}"; do
        echo "   - $field"
    done
    echo ""
    echo "💡 Review and add missing fields manually"
else
    echo "✅ All required fields present"
fi

echo ""

# Open in VS Code if available
if command -v code &> /dev/null; then
    echo "📂 Opening in VS Code..."
    code "$STORY_FILE"
else
    echo "💡 Open the file manually: $STORY_FILE"
fi

echo ""
echo "🎉 Story generation complete!"
echo ""
echo "Next steps:"
echo "  1. Review the generated story YAML"
echo "  2. Refine if needed (acceptance criteria, technical notes)"
echo "  3. Use story YAML for implementation"
echo ""

exit 0
