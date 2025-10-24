# Copilot Agent Instructions

> **Inheritance** — Read `CLAUDE.md` and `AGENTS.md` first; this file only adds Copilot-specific guidance and must stay aligned with the master sections.
> **Copilot style** — Deliver concise, action-focused answers. Prioritize direct edits or command lists and avoid long narratives.
> **Scope** — Excel at small, well-bounded changes. Escalate multi-step design work or ambiguous planning requests back to Claude.

## Project Overview
- RAPID-AI is the task-driven SDLC automation framework extracted from EmberCare.
- VS Code tasks are the primary UX; treat CLI usage as secondary and only suggest it when tasks are unavailable.

## Architecture
- Work from source under `src/`; never edit `dist/` directly—run the build scripts instead.
- Core automation lives in `src/core/**`; adapters in `src/adapters/**`; conversational workflows in `src/rapid/**`.
- `.bmad-core/` and `.bmad-infrastructure-devops/` stay mirrored with runtime assets and supply reusable workflows.

## Development Commands
- Default to `npm run build`, `npm run dev`, `npm test`, and `npm start` for CLI development checks.
- Use `./scripts/build-dist.sh` and `./scripts/validate-structure.sh` when distribution assets must be refreshed.
- Run BMAD utilities (`npm run bmad:refresh`, `npm run bmad:list`, `npm run bmad:validate`) if agent metadata needs syncing.

## Critical Patterns
- Invoke VS Code tasks (see `templates/vscode/tasks.json`) rather than scripting manual steps.
- Respect AI abstraction in `core/scripts/` and `core/workflows/common-functions.sh`; extend adapters instead of touching core prompts.
- Rely on existing environment detection and progress helpers—do not reimplement them.

## Configuration
- Keep `.ai-workflow.yaml` and `src/rapid/rapid-config.yaml` in kebab-case and validated; they toggle workflows and agent behavior.
- Update schemas in `src/schemas/` alongside any prompt or workflow change that affects document structure.

## File Structure & Outputs
- Store generated discovery/plan/QA artifacts under `docs/` with the existing `story-<epic>-<story>-*.md` naming.
- Use `dist/.vscode/` solely as a build output; regenerate rather than editing in place.
- Reference templates and examples in `templates/` and `examples/` when creating new automation patterns.

## Documentation Workflow Integration
- Acknowledge documentation gates managed by `core/scripts/task-completion-verification.sh`; surface blockers clearly.
- When configuration enables completion gates, confirm documentation updates or instruct the user how to satisfy the checklist.

## Testing Philosophy
- Favor deterministic Jest tests colocated with features or in `__tests__/`; stub external CLI calls.
- Call out residual risks when rapid fixes lack regression coverage.

## Key Constraints & Anti-Patterns
- Preserve POSIX compatibility in shell scripts; avoid TypeScript-based AI orchestration.
- Do not break EmberCare compatibility or reintroduce BMAD branding.
- Never bypass VS Code tasks as the first-class interface unless validating CLI-specific paths.

## Project Type Detection
- Flutter (`pubspec.yaml`), React (`package.json` + React deps), Python (`requirements.txt` or `pyproject.toml`), Go (`go.mod`), fallback otherwise.

## Integration Points
- Surface VS Code task usage, expected inputs, and outputs in recommendations.
- Follow Conventional Commits, reference related stories/checklists, and request subsystem maintainers for review.
- For work beyond quick edits or when requirements are unclear, propose handing off to Claude for deeper analysis.
