# Epic YAML Files

This directory contains sharded epic specifications in YAML format.

## Purpose

Epic YAML files define feature groups and story collections. Each epic is a self-contained YAML file that provides context for AI-powered story generation.

## Naming Convention

```
epic-{n}.yaml
```

Examples:
- `epic-1.yaml` - Epic 1: Structured YAML Workflow Foundation
- `epic-2.yaml` - Epic 2: Claude CLI Integration
- `epic-3.yaml` - Epic 3: VS Code Task Enhancement

## Epic YAML Structure

```yaml
epic:
  id: 1
  title: "Epic Title"
  priority: "critical"          # critical|high|medium|low
  status: "in_progress"         # planned|in_progress|completed

  description: |
    Multi-line description of epic scope and purpose

  goals:
    - "Goal 1"
    - "Goal 2"

  success_criteria:
    - "Success metric 1"
    - "Success metric 2"

  documentation:
    updated: "2025-10-23"
    status: "current"
    notes: |
      Epic-level documentation tracking.
      Stories don't require individual doc verification.

  stories:
    - id: 1
      title: "Story 1 Title"
      priority: "critical"
      status: "in_progress"
      estimated_effort: "3-4 hours"
      description: |
        Brief story description
      acceptance_criteria:
        - "Criteria 1"
        - "Criteria 2"

  technical_requirements:
    prerequisites:
      - tool: "Tool name"
        command: "verification command"
        required: true
        purpose: "Why needed"

  risk_assessment:
    - risk: "Risk description"
      impact: "High|Medium|Low"
      mitigation: "How to mitigate"
```

## Relationship to Stories

Epic YAML files provide **context** for story generation:

1. Epic defines the overall feature area
2. Each epic contains brief story summaries
3. Full story details live in `docs/stories/{epic}-{story}-story.yaml`
4. Story generation reads epic context to ensure relevance

## Querying Epics

Use `yq` to query epic files:

### List all epics
```bash
yq eval '.epic.title' docs/prd/epic-*.yaml
```

### Find in-progress epics
```bash
yq eval 'select(.epic.status == "in_progress") | .epic.title' docs/prd/epic-*.yaml
```

### Show all stories in Epic 1
```bash
yq eval '.epic.stories[].title' docs/prd/epic-1.yaml
```

### List critical priority stories across all epics
```bash
yq eval '.epic.stories[] | select(.priority == "critical") | .title' docs/prd/epic-*.yaml
```

## Epic-Level Documentation Tracking

Unlike individual stories, **epics have documentation requirements**:

```yaml
documentation:
  updated: "2025-10-23"
  status: "current"
  notes: |
    Documentation required at epic completion:
    - README.md updates
    - CLAUDE.md philosophy updates
    - Example files in docs/examples/
```

This ensures major features update user-facing documentation without story-level ceremony.

## Current Epics

### Epic 1: Structured YAML Workflow Foundation
**Priority:** Critical
**Status:** In Progress

Establish YAML-first architecture for deterministic AI execution.

**Key Stories:**
1. Generate Story YAML from Epic Context ✅ (IMMEDIATE VALUE)
2. Define Story YAML Schema and Validation
3. Create Epic YAML Schema and Directory Structure
4. Create Working VS Code Task Suite
5. Implement Token Usage Tracking

### Epic 2: Claude CLI Integration (Planned)
**Priority:** Critical
**Status:** Planned

Add Claude CLI support for superior reasoning alongside CoPilot.

### Epic 3: VS Code Task Enhancement (Planned)
**Priority:** High
**Status:** Planned

Update VS Code tasks for seamless YAML workflows.

### Epic 4: Strip BMAD Overhead (Planned)
**Priority:** Medium
**Status:** Planned

Remove BMAD branding and extract useful patterns.

## Creating New Epics

### Manual Creation
Copy an existing epic as template:

```bash
cp docs/prd/epic-1.yaml docs/prd/epic-2.yaml
# Edit epic-2.yaml with new content
```

### AI-Generated (Future)
Story 2.x will add epic generation from product context:

```bash
./core/scripts/generate-epic-yaml.sh 2 "Epic Title"
```

## Validation

Validate epic YAML:

```bash
# Basic YAML syntax check
yq eval . docs/prd/epic-1.yaml

# Schema validation (coming in Epic 1, Story 3)
./scripts/validate-yaml.sh docs/prd/epic-1.yaml
```

## Integration with PRD

Epic files are referenced from main PRD:

```yaml
# docs/prd.yaml
product:
  name: "RAPID-AI 2.0"

  epics_location: "docs/prd/"
  epic_count: 4

  epics_summary:
    - id: 1
      title: "Structured YAML Workflow Foundation"
      status: "in_progress"
```

## Philosophy

**Epics = Feature Groups**
Epics group related stories into coherent feature areas.

**Context for AI**
Epic YAML provides context so AI generates relevant, accurate story specifications.

**Sharded Structure**
Each epic in separate file enables:
- Focused changes (better git diffs)
- Parallel epic development
- Easier querying and automation

## Next Steps

After creating an epic:

1. **Generate Stories** - Use "RAPID: Generate Story from Epic" task
2. **Implement Stories** - Work through stories sequentially
3. **Update Status** - Mark stories complete as finished
4. **Epic Documentation** - Update docs when epic complete
