#!/bin/bash
# Validate dist/.vscode/ structure
# Ensures distribution has all required files and correct structure

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0

echo ""
echo "🔍 Validating dist/.vscode/ structure..."
echo ""

# Check if dist/.vscode/ exists
if [ ! -d "dist/.vscode" ]; then
    echo -e "${RED}❌ dist/.vscode/ does not exist${NC}"
    echo "   Run: ./scripts/build-dist.sh"
    exit 1
fi

# Check required directories
echo -e "${BLUE}Checking directories...${NC}"
REQUIRED_DIRS=(
    "core"
    "core/scripts"
    "core/workflows"
    "core/config"
    "adapters"
    "prompts"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    if [ -d "dist/.vscode/$dir" ]; then
        echo -e "   ${GREEN}✓${NC} dist/.vscode/$dir/"
    else
        echo -e "   ${RED}✗${NC} dist/.vscode/$dir/ ${RED}MISSING${NC}"
        ERRORS=$((ERRORS + 1))
    fi
done

# Check required files
echo ""
echo -e "${BLUE}Checking required files...${NC}"
REQUIRED_FILES=(
    "tasks.json"
    "core/workflows/common-functions.sh"
    "core/config/.ai-workflow.yaml"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "dist/.vscode/$file" ]; then
        echo -e "   ${GREEN}✓${NC} dist/.vscode/$file"
    else
        echo -e "   ${RED}✗${NC} dist/.vscode/$file ${RED}MISSING${NC}"
        ERRORS=$((ERRORS + 1))
    fi
done

# Check optional but recommended files
echo ""
echo -e "${BLUE}Checking optional files...${NC}"
OPTIONAL_FILES=(
    "README.md"
    "settings.json"
)

for file in "${OPTIONAL_FILES[@]}"; do
    if [ -f "dist/.vscode/$file" ]; then
        echo -e "   ${GREEN}✓${NC} dist/.vscode/$file"
    else
        echo -e "   ${YELLOW}⚠${NC}  dist/.vscode/$file ${YELLOW}not found${NC} (optional)"
        WARNINGS=$((WARNINGS + 1))
    fi
done

# Check scripts are executable
echo ""
echo -e "${BLUE}Checking script permissions...${NC}"
SCRIPT_ERRORS=0

if [ -d "dist/.vscode/core/scripts" ]; then
    for script in dist/.vscode/core/scripts/*.sh; do
        if [ -f "$script" ]; then
            if [ -x "$script" ]; then
                echo -e "   ${GREEN}✓${NC} $(basename $script) is executable"
            else
                echo -e "   ${RED}✗${NC} $(basename $script) ${RED}NOT executable${NC}"
                SCRIPT_ERRORS=$((SCRIPT_ERRORS + 1))
            fi
        fi
    done
fi

if [ $SCRIPT_ERRORS -gt 0 ]; then
    echo -e "   ${YELLOW}💡 Fix with: chmod +x dist/.vscode/core/scripts/*.sh${NC}"
    ERRORS=$((ERRORS + SCRIPT_ERRORS))
fi

# Check for legacy BMAD branding (should no longer appear anywhere in dist)
echo ""
echo -e "${BLUE}Scanning for legacy BMAD branding...${NC}"
BMAD_COUNT=$(grep -r "BMAD" dist/.vscode/ 2>/dev/null | grep -v "Binary file" | wc -l || echo "0")
if [ "$BMAD_COUNT" -gt 0 ]; then
    echo -e "   ${RED}✗${NC} Found $BMAD_COUNT references to 'BMAD' in dist/.vscode/"
    echo -e "   ${YELLOW}💡 Remove remaining BMAD references before distributing.${NC}"
    ERRORS=$((ERRORS + 1))
else
    echo -e "   ${GREEN}✓${NC} No BMAD branding found"
fi

# Check file sizes (warn if too large)
echo ""
echo -e "${BLUE}Checking distribution size...${NC}"
DIST_SIZE_KB=$(du -sk dist/.vscode/ | cut -f1)
DIST_SIZE_MB=$((DIST_SIZE_KB / 1024))

if [ $DIST_SIZE_MB -gt 10 ]; then
    echo -e "   ${YELLOW}⚠${NC}  Distribution is ${DIST_SIZE_MB}MB (larger than expected)"
    WARNINGS=$((WARNINGS + 1))
else
    echo -e "   ${GREEN}✓${NC} Distribution size: ${DIST_SIZE_MB}MB"
fi

# Check for common issues
echo ""
echo -e "${BLUE}Checking for common issues...${NC}"

# Check for duplicate files between core and adapters
if [ -f "dist/.vscode/core/workflows/common-functions.sh" ] && \
   [ -f "dist/.vscode/adapters/flutter/workflows/common-functions.sh" ]; then
    echo -e "   ${YELLOW}⚠${NC}  Duplicate common-functions.sh detected"
    WARNINGS=$((WARNINGS + 1))
fi

# Check for empty directories
EMPTY_DIRS=$(find dist/.vscode -type d -empty | wc -l)
if [ $EMPTY_DIRS -gt 0 ]; then
    echo -e "   ${YELLOW}⚠${NC}  Found $EMPTY_DIRS empty directories"
    WARNINGS=$((WARNINGS + 1))
fi

# Summary
echo ""
echo "════════════════════════════════════════"
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ Validation passed!${NC}"
    if [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}⚠  $WARNINGS warnings (non-critical)${NC}"
    fi
    echo "════════════════════════════════════════"
    echo ""
    exit 0
else
    echo -e "${RED}❌ Validation failed with $ERRORS errors${NC}"
    if [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}⚠  Also found $WARNINGS warnings${NC}"
    fi
    echo "════════════════════════════════════════"
    echo ""
    echo "Please fix the errors above and run build again:"
    echo "  ./scripts/build-dist.sh"
    echo ""
    exit 1
fi
