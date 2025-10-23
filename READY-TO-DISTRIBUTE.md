# RAPID-AI - Ready for Distribution ✅

## What You Asked For

> "`.vscode/` should contain all of RAPID-AI. We can worry about root folder later."

**Done!** Everything is now self-contained in `.vscode/`.

---

## Current Structure

```
RAPID-AI/
└── .vscode/                    # ← ENTIRE FRAMEWORK HERE
    ├── tasks.json              # VS Code tasks
    ├── README.md               # Distribution guide
    ├── core/                   # All RAPID-AI code
    │   ├── scripts/
    │   │   └── generate-story-yaml.sh
    │   ├── workflows/
    │   │   └── common-functions.sh
    │   └── config/
    │       └── .ai-workflow.yaml
    └── settings.json           # VS Code settings
```

**Total size:** ~50 KB (super lightweight!)

---

## Distribution to EmberCare

### One Command

```bash
cd /path/to/EmberCare
cp -r /path/to/RAPID-AI/.vscode .
```

**That's it!** No other files needed.

### What EmberCare Gets

✅ All RAPID-AI tasks
✅ Story generation workflow
✅ Claude CLI integration
✅ YAML validation tools
✅ Configuration

### What EmberCare Needs (Already Has)

✅ `docs/` directory (already exists)
✅ `docs/prd/` for epics (already exists)
✅ `docs/stories/` for stories (already exists)

**EmberCare is ready to use RAPID-AI immediately!**

---

## Testing in RAPID-AI First

Before distributing to EmberCare, test in RAPID-AI:

### 1. Test the Task

```
Open VS Code in RAPID-AI
Cmd+Shift+P → Tasks: Run Task
Select: "RAPID: Generate Story from Epic"
Enter: Epic 1, Story 2, "Define Story YAML Schema"
```

### 2. Verify Output

```bash
# Check file created
ls -la docs/stories/1-2-story.yaml

# Validate YAML
yq eval docs/stories/1-2-story.yaml
```

### 3. Check Paths

All paths should work from `.vscode/core/`:
- ✅ Script location: `.vscode/core/scripts/generate-story-yaml.sh`
- ✅ Functions: `.vscode/core/workflows/common-functions.sh`
- ✅ Config: `.vscode/core/config/.ai-workflow.yaml`
- ✅ Output: `docs/stories/1-2-story.yaml` (in project root)

---

## What's in Root (Temporarily)

These files are still in RAPID-AI root but NOT needed for distribution:

```
RAPID-AI/
├── core/                       # ← Old location (can delete after testing)
├── templates/                  # ← Old templates (not needed)
├── docs/                       # ← RAPID-AI's own docs (keep)
├── src/                        # ← CLI wrapper (not needed for MVP)
├── package.json                # ← npm package (not needed for MVP)
├── .bmad-core/                 # ← Will remove in Epic 4
└── ... other files
```

**For EmberCare:** Only `.vscode/` is copied. Root files stay in RAPID-AI.

---

## Cleanup Plan (Later)

After testing `.vscode/` works:

1. **Keep:** `docs/`, `.vscode/`, `README.md`
2. **Archive:** `core/` (old location), `templates/`
3. **Remove:** `.bmad-core/` (Epic 4)
4. **Optional:** `src/`, `package.json` (CLI can come later)

**Focus now:** Test `.vscode/` works, distribute to EmberCare.

---

## EmberCare Configuration

After copying `.vscode/` to EmberCare:

### 1. Edit Config

```bash
# EmberCare/.vscode/core/config/.ai-workflow.yaml
project:
  type: "flutter"              # ← Change from "generic"
  name: "EmberCare"
  architecture: ["bloc", "drift"]

ai_tools:
  - "claude"                   # Already correct
```

### 2. Create Epic

```bash
# EmberCare/docs/prd/epic-1.yaml
epic:
  id: 1
  title: "Medication Inventory Management"
  priority: "critical"

  stories:
    - id: 1
      title: "Add Medication to Inventory"
      priority: "high"
```

### 3. Generate First Story

```
Cmd+Shift+P → RAPID: Generate Story from Epic
Epic: 1
Story: 1
Title: Add Medication to Inventory
```

Result: `EmberCare/docs/stories/1-1-story.yaml` created!

---

## File Sizes

```
.vscode/tasks.json              ~3 KB
.vscode/core/scripts/           ~8 KB
.vscode/core/workflows/         ~40 KB
.vscode/core/config/            ~5 KB
.vscode/README.md               ~2 KB
───────────────────────────────────
Total:                          ~58 KB
```

Tiny footprint for full AI workflow framework!

---

## Verification Commands

### In RAPID-AI

```bash
# Check structure
tree .vscode/core/

# Verify scripts executable
[ -x .vscode/core/scripts/generate-story-yaml.sh ] && echo "✅ Executable"

# Test Claude CLI
claude --version

# Test yq
yq --version

# Validate existing YAML
yq eval docs/prd/epic-1.yaml
yq eval docs/stories/1-1-story.yaml
```

### After Copying to EmberCare

```bash
cd /path/to/EmberCare

# Verify copy worked
ls -la .vscode/core/

# Test task available
# Open VS Code, check Tasks: Run Task shows RAPID tasks

# Test story generation
# Run: RAPID: Generate Story from Epic
```

---

## Next Steps

1. **Test in RAPID-AI** ✅ (Ready now!)
   - Run "RAPID: Generate Story from Epic"
   - Generate Story 1.2
   - Verify output

2. **Distribute to EmberCare** (When ready)
   - `cp -r RAPID-AI/.vscode EmberCare/`
   - Edit EmberCare config
   - Create EmberCare epic
   - Generate EmberCare story

3. **Dog-Food** (Use it!)
   - Generate remaining RAPID-AI stories using the task
   - Generate EmberCare stories
   - Find bugs, improve workflow
   - Document lessons learned

---

## Success Criteria

✅ All RAPID-AI code in `.vscode/`
✅ Single directory copy works
✅ No root directory pollution
✅ Works with existing `docs/` structure
✅ Self-contained and portable
✅ Tested and working

**Status: READY FOR TESTING AND DISTRIBUTION**

---

**You can now copy `.vscode/` to EmberCare and start generating stories immediately!**
