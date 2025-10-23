# Story YAML Files

This directory contains structured story specifications in YAML format.

## Purpose

Story YAML files are **machine-readable specifications** designed for AI consumption, not human conversation. They enable deterministic code generation without natural language interpretation overhead.

## Naming Convention

```
{epic_id}-{story_id}-story.yaml
```

Examples:
- `1-1-story.yaml` - Epic 1, Story 1
- `1-2-story.yaml` - Epic 1, Story 2
- `2-3-story.yaml` - Epic 2, Story 3

## Generation Workflow

### Manual Generation
Use the VS Code task for immediate generation:

1. Open VS Code Command Palette (`Cmd+Shift+P`)
2. Run task: **"RAPID: Generate Story from Epic"**
3. Enter epic ID (e.g., `1`)
4. Enter story ID (e.g., `2`)
5. Enter story title (e.g., `Define Story YAML Schema`)
6. Claude CLI generates structured YAML
7. File opens for review

### Programmatic Generation
Use the shell script directly:

```bash
./core/scripts/generate-story-yaml.sh 1 2 "Story Title"
```

## Story YAML Structure

```yaml
story:
  id: "1.2"                    # Epic.Story format
  epic_id: 1                   # Numeric epic ID
  title: "Story Title"         # Brief, descriptive title
  priority: "critical"         # critical|high|medium|low
  status: "planned"            # planned|in_progress|completed
  created: "2025-10-23"
  updated: "2025-10-23"

  metadata:
    estimated_effort: "2-3 hours"
    actual_effort: null
    assigned_to: "macjunkins"
    tags: ["yaml-foundation", "testing"]

  rationale: |
    WHY this story matters and what value it provides

  description: |
    WHAT the story does - detailed description including:
    - User workflow
    - Technical approach
    - Expected outcomes

  acceptance_criteria:
    - criteria: "Specific, testable requirement"
      validation: "How to verify this is met"

  technical_notes:
    area_name: |
      Technical details, constraints, implementation guidance

  implementation_files:
    create:
      - path: "path/to/new/file.ext"
        purpose: "Why this file is needed"
    modify:
      - path: "path/to/existing/file.ext"
        changes: "What modifications needed"

  testing_approach:
    manual_tests:
      - test: "Test description"
        steps: ["Step 1", "Step 2"]
        expected: "Expected outcome"

  dependencies:
    required:
      - dependency: "What's required"
        validation: "How to check"
        installation: "How to install"

  completion_criteria:
    - "Criteria for story done"
```

## Querying Stories

Use `yq` to query story YAML files:

### Find all planned stories
```bash
yq eval 'select(.story.status == "planned")' docs/stories/*-story.yaml
```

### Get story titles
```bash
yq eval '.story.title' docs/stories/1-*-story.yaml
```

### List all critical priority stories
```bash
yq eval 'select(.story.priority == "critical") | .story.title' docs/stories/*-story.yaml
```

### Show acceptance criteria for a story
```bash
yq eval '.story.acceptance_criteria[].criteria' docs/stories/1-1-story.yaml
```

## Validation

Validate story YAML against schema:

```bash
# Using yq (basic validation)
yq eval . docs/stories/1-1-story.yaml

# Using schema validation (coming in Story 1.2)
./scripts/validate-yaml.sh docs/stories/1-1-story.yaml
```

## Philosophy: YAML-First Workflow

### Why YAML Instead of Markdown?

**Token Efficiency:**
- Markdown requires AI to parse natural language (4.3K tokens)
- YAML is deterministic parsing (1.5-2K tokens)
- **50-70% token savings**

**Deterministic Execution:**
- No interpretation ambiguity
- Schema validation ensures structure
- Queryable and automatable

**AI Consumption:**
- AI reads YAML specifications directly
- No "did you mean..." clarifications needed
- Straight from spec to code

### When to Use Conversation vs YAML

**Conversation Mode** (like we're doing now):
- Ideation and exploration
- Architectural decisions
- Problem solving and brainstorming
- High-level planning

**YAML Mode** (execution):
- Story specifications → Code
- Epic definitions → Story generation
- Implementation plans → Execution
- No back-and-forth, just build

## Migration from Markdown

If you have existing markdown stories, they remain valid during transition. RAPID-AI 2.0 supports both formats:

- **Existing projects:** Can continue using markdown
- **New projects:** Should use YAML-first
- **Migration:** Optional, not required

## Examples

See existing story files in this directory:
- `1-1-story.yaml` - Story generation workflow (meta!)
- Additional stories generated using Story 1.1 workflow

## Next Steps

After generating a story YAML:

1. **Review** - Validate content matches epic context
2. **Refine** - Add missing details if needed
3. **Implement** - Use story as specification for development
4. **Update** - Mark status as in_progress, then completed

## Questions?

See:
- [PRD v2.0](../prd-v2.yaml) - Full architectural vision
- [Epic 1](../prd/epic-1.yaml) - YAML foundation epic
- [CLAUDE.md](../../CLAUDE.md) - Project-level guidance
