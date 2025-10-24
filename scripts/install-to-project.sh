#!/bin/bash
# Install RAPID-AI to target project
# Copies dist/.vscode/ to any project directory

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse arguments
TARGET=$1
FORCE=${2:-false}

# Usage
if [ -z "$TARGET" ]; then
    echo ""
    echo "Usage: $0 /path/to/project [--force]"
    echo ""
    echo "Examples:"
    echo "  $0 /Users/johnjunkins/GitHub/EmberCare"
    echo "  $0 ../MyProject"
    echo "  $0 /path/to/project --force    # Overwrite without backup"
    echo ""
    echo "Options:"
    echo "  --force    Overwrite existing .vscode/ without creating backup"
    echo ""
    exit 1
fi

# Handle --force flag in any position
if [ "$TARGET" == "--force" ] || [ "$FORCE" == "--force" ]; then
    FORCE=true
    if [ "$TARGET" == "--force" ]; then
        echo -e "${RED}❌ Error: Must provide target path before --force${NC}"
        exit 1
    fi
else
    FORCE=false
fi

echo ""
echo "📦 Installing RAPID-AI to target project..."
echo ""

# Validate RAPID-AI dist exists
if [ ! -d "dist/.vscode" ]; then
    echo -e "${RED}❌ Error: dist/.vscode/ not found${NC}"
    echo ""
    echo "Please build distribution first:"
    echo "  ./scripts/build-dist.sh"
    echo ""
    exit 1
fi

# Validate target directory exists
if [ ! -d "$TARGET" ]; then
    echo -e "${RED}❌ Error: Target directory not found: $TARGET${NC}"
    echo ""
    echo "Please provide a valid project directory path"
    echo ""
    exit 1
fi

# Convert to absolute path
TARGET=$(cd "$TARGET" && pwd)

echo -e "${BLUE}Target: $TARGET${NC}"
echo ""

# Pre-flight validation for expected structure
echo -e "${BLUE}🔍 Verifying distribution contents...${NC}"
MISSING=0
for dir in core rapid; do
    if [ ! -d "dist/.vscode/$dir" ]; then
        echo -e "   ${RED}✗${NC} dist/.vscode/$dir missing"
        MISSING=$((MISSING + 1))
    else
        echo -e "   ${GREEN}✓${NC} dist/.vscode/$dir found"
    fi
done
if [ ! -f "dist/.vscode/tasks.json" ]; then
    echo -e "   ${RED}✗${NC} dist/.vscode/tasks.json missing"
    MISSING=$((MISSING + 1))
fi

if [ $MISSING -gt 0 ]; then
    echo -e "${RED}❌ Distribution is incomplete${NC}"
    echo "Please rebuild before installing:"
    echo "  ./scripts/build-dist.sh"
    exit 1
fi

# Check if target has .vscode/ already
if [ -d "$TARGET/.vscode" ]; then
    echo -e "${YELLOW}⚠  Target already has .vscode/ directory${NC}"

    if [ "$FORCE" = true ]; then
        echo -e "${YELLOW}   Force mode: Overwriting without backup${NC}"
        rm -rf "$TARGET/.vscode"
    else
        # Create timestamped backup
        TIMESTAMP=$(date +%Y%m%d-%H%M%S)
        BACKUP_NAME=".vscode.backup-$TIMESTAMP"

        echo -e "${BLUE}   Creating backup: $BACKUP_NAME${NC}"
        mv "$TARGET/.vscode" "$TARGET/$BACKUP_NAME"
        echo -e "   ${GREEN}✓${NC} Backed up to $TARGET/$BACKUP_NAME"
    fi
    echo ""
fi

# Copy distribution
echo -e "${BLUE}📁 Copying dist/.vscode/ → $TARGET/.vscode/${NC}"
mkdir -p "$TARGET/.vscode"
rsync -a dist/.vscode/ "$TARGET/.vscode/" 2>/dev/null || cp -R dist/.vscode/. "$TARGET/.vscode/"

# Verify installation
if [ -d "$TARGET/.vscode/core" ] && [ -f "$TARGET/.vscode/tasks.json" ]; then
    echo -e "${GREEN}✓ Installation successful${NC}"
else
    echo -e "${RED}✗ Installation may be incomplete${NC}"
    exit 1
fi

# Calculate size
INSTALL_SIZE=$(du -sh "$TARGET/.vscode" | cut -f1)

echo ""
echo -e "${GREEN}✅ RAPID-AI installed to $TARGET${NC}"
echo ""
echo "📊 Installation size: $INSTALL_SIZE"
echo ""
echo "Next steps:"
echo ""
echo "  1. Configure for your project:"
echo "     ${BLUE}$TARGET/.vscode/core/config/.ai-workflow.yaml${NC}"
echo ""
echo "     Example configurations:"
echo "       • Flutter: project.type: 'flutter', architecture: ['bloc', 'drift']"
echo "       • React:   project.type: 'react', architecture: ['redux', 'hooks']"
echo "       • Python:  project.type: 'python', architecture: ['fastapi']"
echo ""
echo "  2. Open VS Code in target project:"
echo "     ${BLUE}cd $TARGET && code .${NC}"
echo ""
echo "  3. Test VS Code tasks:"
echo "     ${BLUE}Cmd+Shift+P → 'RAPID: Test Claude CLI'${NC}"
echo ""
echo "  4. Generate your first story:"
echo "     ${BLUE}Cmd+Shift+P → 'RAPID: Generate Story from Epic'${NC}"
echo ""

# Check for project-specific setup
if [ -f "$TARGET/pubspec.yaml" ]; then
    echo -e "${BLUE}💡 Detected Flutter project${NC}"
    echo "   Recommended config: project.type: 'flutter'"
    echo ""
elif [ -f "$TARGET/package.json" ]; then
    if grep -q "\"react\"" "$TARGET/package.json" 2>/dev/null; then
        echo -e "${BLUE}💡 Detected React project${NC}"
        echo "   Recommended config: project.type: 'react'"
        echo ""
    fi
elif [ -f "$TARGET/requirements.txt" ] || [ -f "$TARGET/pyproject.toml" ]; then
    echo -e "${BLUE}💡 Detected Python project${NC}"
    echo "   Recommended config: project.type: 'python'"
    echo ""
elif [ -f "$TARGET/go.mod" ]; then
    echo -e "${BLUE}💡 Detected Go project${NC}"
    echo "   Recommended config: project.type: 'go'"
    echo ""
fi
