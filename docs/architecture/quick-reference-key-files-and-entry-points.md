# Quick Reference - Key Files and Entry Points

## Critical Files for Understanding the System

- **VS Code Integration**: `templates/vscode/tasks.json` (PRIMARY FOCUS - must work reliably)
- **Core Engine**: `core/scripts/ai-discovery.sh`, `core/scripts/ai-implementation-plan.sh`
- **Framework Functions**: `core/workflows/common-functions.sh` (AI integration, environment detection)
- **Flutter Adapter**: `adapters/flutter/scripts/flutter-discovery.sh` (proven EmberCare implementation)
- **Configuration Template**: `.ai-workflow.yaml` (project configuration)
- **CLI Wrapper**: `src/cli.js` (optional interaction method, secondary priority)
- **Package Definition**: `package.json` (npm distribution)

## Enhancement Impact Areas (Immediate Priorities)

**Phase 1 Target Areas (VS Code Tasks + Systematic SDLC):**
- `templates/vscode/tasks.json` - PRIMARY: ensure tasks work reliably across projects
- `core/workflows/common-functions.sh` - improve AI integration reliability
- `.bmad-core/` directory - EXTRACT useful workflows/templates (remove branding)
- Systematic SDLC process definition (new) - deliberate AI-powered development workflow

**Future Enhancement Areas:**
- `src/cli.js` - CLI wrapper as optional interaction method (not primary focus)
- Multi-AI model support - extending beyond GitHub Copilot
- Dashboard system - simple project status/progress tracking
