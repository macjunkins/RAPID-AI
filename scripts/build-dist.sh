#!/bin/bash
# Build RAPID-AI distribution from source
# Creates dist/.vscode/ bundle ready for distribution

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo "🔨 Building RAPID-AI distribution..."
echo ""

# Validate we're in RAPID-AI root
if [ ! -d "src/core" ] || [ ! -d "src/adapters" ]; then
    echo -e "${RED}❌ Error: Must run from RAPID-AI root directory${NC}"
    echo "   Expected: src/core/ and src/adapters/ to exist"
    exit 1
fi

# Clean dist/.vscode/
echo -e "${BLUE}📁 Cleaning dist/.vscode/...${NC}"
rm -rf dist/.vscode
mkdir -p dist/.vscode

# Helper to copy directories with better logging
copy_dir() {
    local source_dir="$1"
    local target_dir="$2"
    local description="$3"
    local required="${4:-optional}"

    echo -e "${BLUE}📦 Copying ${description}...${NC}"
    if [ -d "$source_dir" ]; then
        mkdir -p "$(dirname "$target_dir")"
        rsync -a "$source_dir/" "$target_dir/" 2>/dev/null || cp -R "$source_dir/." "$target_dir/"
        echo -e "   ${GREEN}✓${NC} Copied ${source_dir} → ${target_dir}"
    else
        if [ "$required" = "required" ]; then
            echo -e "   ${RED}✗${NC} ${source_dir} not found"
            exit 1
        fi
        echo -e "   ${YELLOW}⚠${NC}  ${source_dir} not found (skipping)"
    fi
}

# Copy source frameworks
copy_dir "src/core" "dist/.vscode/core" "core framework" "required"
copy_dir "src/rapid" "dist/.vscode/rapid" "RAPID conversational framework" "required"
copy_dir "src/adapters" "dist/.vscode/adapters" "adapters"
copy_dir "src/prompts" "dist/.vscode/prompts" "prompt templates"
copy_dir "src/schemas" "dist/.vscode/schemas" "YAML schemas"

# Copy VS Code config files from templates
echo -e "${BLUE}📦 Copying VS Code config...${NC}"
if [ -f "templates/vscode/tasks.json" ]; then
    cp templates/vscode/tasks.json dist/.vscode/tasks.json
    echo -e "   ${GREEN}✓${NC} Copied templates/vscode/tasks.json"
else
    echo -e "   ${RED}✗${NC} templates/vscode/tasks.json not found"
    exit 1
fi

if [ -f "templates/vscode/README.md" ]; then
    cp templates/vscode/README.md dist/.vscode/README.md
    echo -e "   ${GREEN}✓${NC} Copied templates/vscode/README.md"
else
    echo -e "   ${YELLOW}⚠${NC}  templates/vscode/README.md not found (skipping)"
fi

# Optional: copy additional VS Code assets when present
for file in settings.json extensions.json; do
    if [ -f "templates/vscode/$file" ]; then
        cp "templates/vscode/$file" "dist/.vscode/$file"
        echo -e "   ${GREEN}✓${NC} Copied templates/vscode/$file"
    fi
done

# Make scripts executable
echo -e "${BLUE}🔧 Making scripts executable...${NC}"
if [ -d "dist/.vscode/core/scripts" ]; then
    chmod +x dist/.vscode/core/scripts/*.sh
    echo -e "   ${GREEN}✓${NC} Made core/scripts/*.sh executable"
fi

if [ -d "dist/.vscode/adapters" ]; then
    find dist/.vscode/adapters -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
    echo -e "   ${GREEN}✓${NC} Made adapter scripts executable"
fi

if [ -d "dist/.vscode/rapid" ]; then
    find dist/.vscode/rapid -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
fi

# Validate structure
echo ""
echo -e "${BLUE}🔍 Validating structure...${NC}"
if [ -f "scripts/validate-structure.sh" ]; then
    ./scripts/validate-structure.sh
else
    echo -e "   ${YELLOW}⚠${NC}  validation script not found (skipping)"
fi

# Calculate size
DIST_SIZE=$(du -sh dist/.vscode/ | cut -f1)

echo ""
echo -e "${GREEN}✅ Build complete!${NC}"
echo ""
echo "📁 Distribution: dist/.vscode/"
echo "📊 Size: $DIST_SIZE"
echo ""
echo "Next steps:"
echo "  • Test in RAPID-AI: cp -r dist/.vscode/core .vscode/core"
echo "  • Install to project: ./scripts/install-to-project.sh /path/to/project"
echo "  • Validate: ./scripts/validate-structure.sh"
echo ""
