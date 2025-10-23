#!/bin/bash

# RAPID-AI Installation Script
# Copies RAPID-AI framework to target project

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-.}"

echo "🚀 RAPID-AI Installation"
echo "======================="
echo ""
echo "Source: $SCRIPT_DIR"
echo "Target: $TARGET_DIR"
echo ""

# Validate target directory
if [ ! -d "$TARGET_DIR" ]; then
    echo "❌ Target directory does not exist: $TARGET_DIR"
    echo ""
    echo "Usage: ./install-rapid-ai.sh [target-directory]"
    echo ""
    exit 1
fi

cd "$TARGET_DIR"

echo "📦 Installing RAPID-AI framework..."
echo ""

# Copy VS Code tasks
echo "  ✓ Copying .vscode/"
cp -r "$SCRIPT_DIR/.vscode" .

# Copy core framework
echo "  ✓ Copying core/"
cp -r "$SCRIPT_DIR/core" .

# Copy configuration
echo "  ✓ Copying .ai-workflow.yaml"
cp "$SCRIPT_DIR/.ai-workflow.yaml" .

# Create directory structure
echo "  ✓ Creating docs/prd/"
mkdir -p docs/prd

echo "  ✓ Creating docs/stories/"
mkdir -p docs/stories

# Make scripts executable
echo "  ✓ Making scripts executable"
chmod +x core/scripts/*.sh

echo ""
echo "✅ RAPID-AI installed successfully!"
echo ""

# Verify prerequisites
echo "🔍 Checking prerequisites..."
echo ""

if command -v claude &> /dev/null; then
    echo "  ✅ Claude CLI: $(claude --version | head -n 1)"
else
    echo "  ❌ Claude CLI not found"
    echo "     Install: Included with Claude subscription"
fi

if command -v yq &> /dev/null; then
    echo "  ✅ yq: $(yq --version)"
else
    echo "  ⚠️  yq not found (optional but recommended)"
    echo "     Install: brew install yq"
fi

echo ""
echo "📋 Next steps:"
echo ""
echo "1. Configure for your project:"
echo "   - Edit .ai-workflow.yaml"
echo "   - Set project.type (e.g., 'flutter', 'react', 'python')"
echo "   - Set project.architecture (e.g., ['bloc', 'drift'])"
echo ""
echo "2. Create your first epic:"
echo "   - Copy template: cp $SCRIPT_DIR/docs/prd/epic-1.yaml docs/prd/epic-1.yaml"
echo "   - Edit docs/prd/epic-1.yaml with your features"
echo ""
echo "3. Generate your first story:"
echo "   - Open VS Code in this project"
echo "   - Cmd+Shift+P → Tasks: Run Task"
echo "   - Select: RAPID: Generate Story from Epic"
echo "   - Enter epic, story, title"
echo ""
echo "📚 Documentation:"
echo "   - .vscode/README.md - VS Code tasks guide"
echo "   - $SCRIPT_DIR/DISTRIBUTION-CHECKLIST.md - Full setup guide"
echo "   - $SCRIPT_DIR/docs/stories/README.md - Story YAML guide"
echo ""

exit 0
