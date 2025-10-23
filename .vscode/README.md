# RAPID-AI Framework

**Self-contained AI development workflow framework for VS Code.**

## Installation (Copy to Any Project)

```bash
# From your project root (e.g., EmberCare)
cp -r /path/to/RAPID-AI/.vscode .
```

**That's it!** All RAPID-AI functionality is now available.

## Structure

```
.vscode/
├── tasks.json              # VS Code tasks (main interface)
├── core/                   # RAPID-AI framework (self-contained)
│   ├── scripts/
│   │   └── generate-story-yaml.sh
│   ├── workflows/
│   │   └── common-functions.sh
│   └── config/
│       └── ai-workflow.yaml
└── README.md               # This file
```

**Key Benefit:** Entire framework lives in `.vscode/` - no root directory pollution!

## Tasks Available

### Story Generation
- **RAPID: Generate Story from Epic** - Generate story YAML using Claude CLI

### Testing & Validation
- **RAPID: Test Claude CLI** - Verify Claude CLI installed
- **RAPID: Validate YAML Files** - Check all YAML files valid
- **RAPID: Query All Stories** - List stories with status
- **RAPID: Show Epic Summary** - Display epic summary

## Prerequisites

1. **Claude CLI** - `claude --version`
2. **yq** - `brew install yq` (macOS)
3. **Existing `docs/` structure:**
   - `docs/prd/` - Epic YAML files
   - `docs/stories/` - Story YAML files (created automatically)

## Usage

1. **Open Command Palette** - `Cmd+Shift+P`
2. **Run Task** - "Tasks: Run Task"
3. **Select** - "RAPID: Generate Story from Epic"
4. **Enter** - Epic ID, Story ID, Title
5. **Review** - Generated `docs/stories/{epic}-{story}-story.yaml`

## Configuration

Edit `.vscode/core/config/ai-workflow.yaml` for your project:

```yaml
project:
  type: "flutter"              # Your project type
  architecture: ["bloc", "drift"]

ai_tools:
  - "claude"                   # AI tool to use
```

## Distribution to EmberCare

```bash
cd /path/to/EmberCare
cp -r /path/to/RAPID-AI/.vscode .
```

Done! No additional files needed.
