# RAPID-AI Distribution Checklist

## What to Copy to Another Project (e.g., EmberCare)

### Minimum Required Files

```bash
# 1. VS Code Tasks (user interface)
.vscode/
├── tasks.json          # All RAPID-AI tasks
└── README.md           # Task documentation

# 2. Core Scripts (execution logic)
core/
├── scripts/
│   └── generate-story-yaml.sh      # Story generator
└── workflows/
    └── common-functions.sh          # AI abstraction layer

# 3. Configuration
.ai-workflow.yaml       # AI tool configuration

# 4. Directory Structure (create if doesn't exist)
docs/
├── prd/                # Epic YAML files
│   └── epic-1.yaml     # (or create your own)
└── stories/            # Generated story YAML files
```

---

## Step-by-Step Distribution

### Option 1: Full Copy (Recommended for MVP Testing)

```bash
# From EmberCare project root
cd /path/to/EmberCare

# Copy VS Code tasks
cp -r /path/to/RAPID-AI/.vscode .

# Copy core framework
cp -r /path/to/RAPID-AI/core .

# Copy configuration template
cp /path/to/RAPID-AI/.ai-workflow.yaml .

# Create directory structure
mkdir -p docs/prd
mkdir -p docs/stories

# Copy example epic (optional - or create your own)
cp /path/to/RAPID-AI/docs/prd/epic-1.yaml docs/prd/embercare-epic-1.yaml
```

**Result:** EmberCare can immediately run "RAPID: Generate Story from Epic"

---

### Option 2: Minimal Install (Just Story Generation)

If you only want story generation (Story 1.1 feature):

```bash
# From EmberCare root
mkdir -p .vscode core/scripts core/workflows docs/prd docs/stories

# Copy only what's needed for story generation
cp /path/to/RAPID-AI/.vscode/tasks.json .vscode/
cp /path/to/RAPID-AI/core/scripts/generate-story-yaml.sh core/scripts/
cp /path/to/RAPID-AI/core/workflows/common-functions.sh core/workflows/
cp /path/to/RAPID-AI/.ai-workflow.yaml .

# Make script executable
chmod +x core/scripts/generate-story-yaml.sh
```

---

### Option 3: Selective Integration (Existing .vscode/)

If EmberCare already has `.vscode/tasks.json`:

```bash
# Copy RAPID-AI core
cp -r /path/to/RAPID-AI/core /path/to/EmberCare/
cp /path/to/RAPID-AI/.ai-workflow.yaml /path/to/EmberCare/

# Manually merge tasks into existing .vscode/tasks.json
# Add RAPID tasks from RAPID-AI/.vscode/tasks.json to EmberCare's tasks array
```

---

## Files Breakdown

### 1. .vscode/tasks.json (Required)

**What it does:** VS Code task definitions
**Size:** ~4 KB
**Dependencies:** None (self-contained)

**Tasks provided:**
- RAPID: Generate Story from Epic
- RAPID: Test Claude CLI
- RAPID: Validate YAML Files
- RAPID: Query All Stories
- RAPID: Show Epic Summary

---

### 2. core/scripts/generate-story-yaml.sh (Required for Story Gen)

**What it does:** Generates story YAML from epic context using Claude CLI
**Size:** ~8 KB
**Dependencies:**
- `core/workflows/common-functions.sh`
- Claude CLI installed
- Epic YAML file in `docs/prd/`

**Functions:**
- Reads epic context
- Builds Claude prompt
- Generates story YAML
- Validates output
- Opens in VS Code

---

### 3. core/workflows/common-functions.sh (Required)

**What it does:** Shared functions for AI integration
**Size:** ~40 KB
**Dependencies:** None (POSIX-compatible bash)

**Functions used by story generation:**
- `detect_environment()` - VS Code vs terminal
- `check_ai_tool_availability()` - Verify Claude CLI
- AI tool abstraction (future: support CoPilot fallback)

**Note:** This file has many functions for other RAPID-AI features. For MVP, only a few are used.

---

### 4. .ai-workflow.yaml (Recommended)

**What it does:** Configuration for AI tools and workflows
**Size:** ~3 KB
**Dependencies:** None

**Key settings for EmberCare:**
```yaml
project:
  type: "flutter"           # ← Change to "flutter" for EmberCare
  architecture: ["bloc", "drift"]

ai_tools:
  - "claude"                # ← Primary AI tool

workflows:
  story_analysis:
    ai_tool: "claude"
    output_format: "yaml"   # ← YAML-first
    outputs:
      - "docs/stories/{epic}-{story}-story.yaml"
```

---

### 5. docs/prd/ Directory Structure

**What it does:** Holds epic YAML files
**Required:** Yes (at least one epic file)

**For EmberCare:**
```bash
docs/prd/
└── epic-1.yaml         # Define EmberCare's first epic
```

**Create your own epic or copy template:**
```bash
# Copy RAPID-AI epic as template
cp /path/to/RAPID-AI/docs/prd/epic-1.yaml docs/prd/embercare-epic-1.yaml

# Edit to define EmberCare features
```

---

### 6. docs/stories/ Directory

**What it does:** Stores generated story YAML files
**Required:** Yes (empty directory is fine)

```bash
mkdir -p docs/stories
```

Generated stories will be saved here:
- `docs/stories/1-1-story.yaml`
- `docs/stories/1-2-story.yaml`
- etc.

---

## Prerequisites for Target Project

### System Requirements

1. **Claude CLI**
   ```bash
   claude --version
   ```
   Install: Included with Claude subscription

2. **yq (YAML processor)**
   ```bash
   yq --version
   ```
   Install: `brew install yq` (macOS)

3. **Bash shell**
   - macOS/Linux: Built-in
   - Windows: Git Bash or WSL

---

## EmberCare-Specific Configuration

### Update .ai-workflow.yaml for EmberCare

```yaml
project:
  type: "flutter"                    # ← EmberCare is Flutter
  name: "EmberCare"
  architecture: ["bloc", "drift"]     # ← EmberCare patterns

ai_tools:
  - "claude"                          # ← Use Claude for reasoning

workflows:
  story_analysis:
    ai_tool: "claude"
    output_format: "yaml"
    outputs:
      - "docs/stories/{epic}-{story}-story.yaml"
```

### Create EmberCare Epic

Create `docs/prd/embercare-epic-1.yaml`:

```yaml
epic:
  id: 1
  title: "Medication Inventory Management"
  priority: "critical"
  status: "planned"

  description: |
    Core medication tracking features for EmberCare.

  stories:
    - id: 1
      title: "Add Medication to Inventory"
      priority: "high"
      description: "Users can add medications with name, dosage, quantity"

    - id: 2
      title: "View Medication List"
      priority: "high"
      description: "Display all medications in inventory"
```

---

## Quick Start for EmberCare

### Full Distribution (Copy Everything)

```bash
#!/bin/bash
# From EmberCare project root

RAPID_AI="/path/to/RAPID-AI"
EMBERCARE="/path/to/EmberCare"

cd "$EMBERCARE"

# Copy RAPID-AI framework
cp -r "$RAPID_AI/.vscode" .
cp -r "$RAPID_AI/core" .
cp "$RAPID_AI/.ai-workflow.yaml" .

# Create directories
mkdir -p docs/prd docs/stories

# Make scripts executable
chmod +x core/scripts/*.sh

echo "✅ RAPID-AI installed in EmberCare"
echo ""
echo "Next steps:"
echo "1. Edit .ai-workflow.yaml (set type: 'flutter')"
echo "2. Create docs/prd/epic-1.yaml with EmberCare features"
echo "3. Run: RAPID: Generate Story from Epic"
```

---

## Verification

After copying files, verify installation:

```bash
# Check files exist
ls -la .vscode/tasks.json
ls -la core/scripts/generate-story-yaml.sh
ls -la core/workflows/common-functions.sh
ls -la .ai-workflow.yaml

# Check script executable
[ -x core/scripts/generate-story-yaml.sh ] && echo "✅ Script executable"

# Check prerequisites
claude --version && echo "✅ Claude CLI ready"
yq --version && echo "✅ yq ready"

# Check directories
[ -d docs/prd ] && echo "✅ docs/prd exists"
[ -d docs/stories ] && echo "✅ docs/stories exists"
```

---

## What NOT to Copy

These stay in RAPID-AI only:

- ❌ `templates/` - Distribution templates, not needed in target projects
- ❌ `adapters/` - Adapter code (copy only if using adapters)
- ❌ `src/` - CLI wrapper (optional, not needed for VS Code tasks)
- ❌ `package.json` - npm package, not needed
- ❌ `.bmad-core/` - BMAD content (being removed in Epic 4)
- ❌ `docs/prd-v2.yaml` - RAPID-AI's own PRD
- ❌ `STORY-1.1-COMPLETE.md` - RAPID-AI development docs

---

## File Sizes

```
.vscode/tasks.json              ~4 KB
core/scripts/generate-story-yaml.sh  ~8 KB
core/workflows/common-functions.sh   ~40 KB
.ai-workflow.yaml               ~3 KB
docs/prd/epic-1.yaml (template) ~6 KB
───────────────────────────────────────
Total:                          ~61 KB
```

**Tiny footprint** - less than 100 KB for full RAPID-AI story generation workflow!

---

## Summary: Minimum EmberCare Setup

```
EmberCare/
├── .vscode/
│   └── tasks.json                   # VS Code tasks
├── core/
│   ├── scripts/
│   │   └── generate-story-yaml.sh  # Story generator
│   └── workflows/
│       └── common-functions.sh      # AI abstraction
├── .ai-workflow.yaml                # Configuration (edit for Flutter)
└── docs/
    ├── prd/
    │   └── epic-1.yaml              # Define EmberCare features
    └── stories/                     # Generated stories go here
```

**Result:** Run "RAPID: Generate Story from Epic" in EmberCare immediately!
