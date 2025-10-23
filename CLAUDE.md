# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**RAPID-AI** is a systematic AI-powered SDLC framework that automates story analysis and implementation planning through AI integration. Extracted from the production EmberCare healthcare app, it provides structured, repeatable processes for AI-assisted development.

**Key Concept**: This is NOT a traditional application - it's a **task-driven workflow automation framework** where VS Code tasks (in `templates/vscode/tasks.json`) are the primary user interface, calling core shell scripts that integrate with AI tools.

## Architecture

### Three-Layer Design + BMAD Integration

1. **Core Framework** (`core/`): Language-agnostic shell scripts and AI integration
   - `core/scripts/`: Primary automation scripts (ai-discovery.sh, ai-implementation-plan.sh, etc.)
   - `core/workflows/`: Shared functions and systematic workflows
   - `core/workflows/common-functions.sh`: Environment detection, AI tool abstraction, progress indicators

2. **Adapters** (`adapters/`): Project-specific implementations
   - `adapters/flutter/`: Flutter + BLoC + Drift adapter (production-proven from EmberCare)
   - Future: React, Python, Go adapters

3. **Templates & CLI** (`templates/`, `src/`):
   - `templates/vscode/tasks.json`: VS Code tasks (primary interface)
   - `src/cli.js`: Optional CLI wrapper for command-line users

4. **BMAD Method Integration** (`.bmad-core/`, `.bmad-infrastructure-devops/`):
   - Agent definitions with structured roles (dev, architect, pm, qa, etc.)
   - Systematic workflows and tasks extracted from BMAD methodology
   - **Documentation workflow integration**: Mandatory documentation verification before task completion
   - Quality checklists and document templates

## Development Commands

### Framework Development
```bash
npm run build          # Compile TypeScript CLI
npm run dev            # Watch mode for CLI development
npm test               # Run test suite
```

### BMAD Integration
```bash
npm run bmad:refresh   # Regenerate AGENTS.md from .bmad-core/
npm run bmad:list      # List available agents
npm run bmad:validate  # Validate BMAD configuration
```

### CLI Usage (Secondary Interface)
```bash
npx rapid init --type flutter --ai copilot
npx rapid analyze 1 4 "User Authentication"
npx rapid plan 1 4 "User Authentication"
npx rapid setup 1 4 "User Authentication"
```

### VS Code Tasks (Primary Interface)
Access via Command Palette (`Cmd+Shift+P`):
- **AI Workflow: Analyze Story** - Run AI-powered story analysis
- **AI Workflow: Generate Implementation Plan** - Create implementation plan
- **AI Workflow: Flutter Analysis** - Flutter-specific analysis (requires Flutter adapter)
- **AI Workflow: Complete Story Setup** - Run full workflow (analysis → plan → documentation)
- **Systematic: Project Analysis** - Brownfield codebase analysis
- **Systematic: Quality Checklist** - Interactive quality validation
- **Systematic: Document Generator** - Automated documentation generation

## Critical Patterns

### VS Code Tasks Integration
Tasks provide parameterized inputs using `${input:epic}`, `${input:story}`, `${input:title}` variables. Problem matchers detect workflow errors with patterns like `"❌\\s+(.+)$"`. Tasks call shell scripts directly without requiring npm installation.

### AI Tool Abstraction
AI tools are abstracted through `run_ai_analysis()` in `core/workflows/common-functions.sh`:
- **GitHub Copilot CLI**: Fully implemented (`copilot -p "prompt"`)
- **Claude/GPT-4**: Placeholder functions for future expansion
- Timeout protection prevents hanging on AI calls

### Environment-Aware Progress
The `detect_environment()` function adapts behavior for VS Code, Codespaces, or terminal, providing appropriate progress indicators and file opening behavior for each context.

### Project-Specific Prompts
Each adapter customizes AI prompts for specific architecture patterns. The Flutter adapter (`adapters/flutter/scripts/flutter-discovery.sh`) provides EmberCare production-tested prompts for BLoC + Drift architecture.

## Configuration

### `.ai-workflow.yaml`
Project configuration drives framework behavior:

```yaml
project:
  type: "flutter"  # Determines which adapter to use
  architecture: ["bloc", "drift"]  # Passed to AI prompts

ai_tools:
  - "copilot"  # Tool selection

workflows:
  story_analysis:
    enabled: true
    timeout: 120
    outputs:
      - "docs/discovery/{epic}-{story}-discovery.md"
      - "docs/plans/{epic}-{story}-plan.md"

systematic:
  enabled: true  # Enable systematic SDLC workflows

integrations:
  vscode:
    enabled: true
    auto_open_files: true
  git:
    auto_branch: true
    branch_pattern: "story/{epic}-{story}-{slug}"
```

## File Structure & Outputs

### Discovery Documents
Generated in `docs/discovery/story-{epic}-{story}-discovery.md` with:
- AI analysis metadata (tool, date, status)
- Project-specific technical guidance (Drift schemas for Flutter, component specs for React)
- Implementation file lists with exact paths
- Testing strategies appropriate to the architecture

### BMAD Integration Outputs
- `.bmad-core/agents/`: Agent definitions (dev, architect, pm, qa, etc.)
- `.bmad-core/tasks/`: Reusable workflow tasks including documentation workflow
- `.bmad-core/checklists/`: Validation checklists (story-dod-checklist, documentation-currency-checklist)
- `.bmad-core/templates/`: Document templates
- `AGENTS.md`: Auto-generated agent summaries (regenerated via `npm run bmad:refresh`)

## Documentation Workflow Integration

The framework includes **optional documentation verification** integrated into development workflows:

### Core Documentation Features

1. **Documentation Detection** (`core/scripts/doc-detection.sh`):
   - Automatically detects when file changes require documentation updates
   - Pattern-based mapping of code changes to documentation files
   - Multiple analysis modes: git-diff, specific files, AI-powered suggestions
   - Adapter-specific detection via configuration (e.g., Flutter BLoC/Drift mapping)

2. **Task Completion Verification** (`core/scripts/task-completion-verification.sh`):
   - Optional documentation verification before task completion
   - Configurable blocking based on severity (critical/major/minor)
   - Systematic checklist validation
   - AI-powered gap analysis with actionable recommendations

3. **Documentation Currency Checklist** (`core/checklists/documentation-currency-checklist.md`):
   - Comprehensive systematic validation across all documentation dimensions
   - Generalized from BMAD patterns for any project type
   - Project-type specific sections via adapters
   - Severity-based prioritization

### Progressive Enhancement Design

Documentation features use a **progressive enhancement** approach:

- **Level 1 (Default):** Detection only - identifies documentation needs (informational)
- **Level 2:** AI-powered suggestions - comprehensive gap analysis with recommendations
- **Level 3:** Completion gate - blocks task completion for critical gaps (optional)

**Configuration-Driven:**
```yaml
documentation_workflow:
  enabled: true  # Enable documentation features
  detection:
    enabled: true  # Detect documentation needs
  ai_analysis:
    enabled: true  # AI-powered suggestions
  completion_gate:
    enabled: false  # Don't block by default (progressive enhancement)
```

### Adapter Integration

**Flutter Adapter** (`adapters/flutter/`):
- Flutter-specific documentation mapping via `config/doc-mapping.yaml`
- BLoC/Drift/UI changes mapped to relevant documentation
- EmberCare-compatible patterns preserved
- Non-breaking enhancement (additive only)

**Future Adapters:**
- React, Python, Go adapters will follow same enhancement pattern
- Each adapter defines project-type specific documentation mappings

### VS Code Task Integration

**Documentation-Aware Tasks:**
- 6 enhanced workflow tasks include documentation detection
- 4 documentation helper tasks (status check, guidelines, interactive helper)
- Problem matchers surface documentation issues in Problems panel
- Progress indicators show documentation status

**Backward Compatibility:**
- All documentation features can be disabled via configuration
- Existing workflows unchanged when documentation features disabled
- EmberCare adapter maintains 100% compatibility
- No performance impact when features disabled

This ensures user-facing documentation stays current with development changes while maintaining development velocity and preserving existing RAPID-AI functionality.

## Testing Philosophy

### Production-Proven (EmberCare)
- Framework generates technically accurate Flutter/Dart/BLoC code
- AI analysis matches actual implementation patterns 95%+ of the time
- Fallback templates prevent blocking when AI fails

### Architecture Validation
Generated analysis must include:
- Database schema definitions (Drift tables for Flutter)
- State management patterns (BLoC events/states for Flutter)
- Component hierarchies with specific file paths
- Testing approaches (bloc_test, flutter_test, mocktail)

## Key Constraints & Anti-Patterns

### Shell Script Portability
- All core logic in POSIX-compatible bash for maximum compatibility
- Environment detection handles VS Code, Codespaces, terminal differences
- Timeout protection prevents hanging on AI calls

### EmberCare Backward Compatibility
Framework extraction maintains 100% compatibility with existing EmberCare scripts - they become thin wrappers calling the framework.

### Anti-Patterns to Avoid
❌ **Don't** hardcode AI prompts in CLI code - use adapter scripts
❌ **Don't** assume npm/Node.js in core scripts - they run in any shell
❌ **Don't** break EmberCare compatibility - it's the proven reference implementation
❌ **Don't** implement AI integrations in TypeScript - shell scripts are more portable
❌ **Don't** bypass VS Code tasks as primary interface - CLI is secondary convenience
❌ **Don't** modify BMAD branding in extracted content - remove it cleanly

## Project Type Detection

Project types are auto-detected based on presence of key files:
- **Flutter**: `pubspec.yaml` present
- **React**: `package.json` with React dependencies
- **Python**: `requirements.txt` or `pyproject.toml`
- **Go**: `go.mod`
- **Generic**: Fallback for unknown project types

## Integration Points

### VS Code Tasks
- Framework provides `templates/vscode/tasks.json` with parameterized inputs
- Tasks call framework scripts directly: `${workspaceFolder}/core/scripts/ai-discovery.sh`
- Problem matchers detect AI workflow errors
- Input variables provide interactive prompts for epic/story/title

### Git Workflow
- Optional auto-branching with configurable patterns
- Branch naming: `story/{epic}-{story}-{slug}` (configurable)
- No auto-commit by default (user control)

### Documentation Generation
- Auto-generate markdown documents with metadata
- Include AI analysis, implementation guidance, file lists
- Systematic documentation workflows for brownfield projects
- Documentation currency validation integrated into development workflow
