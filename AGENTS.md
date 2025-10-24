# Agent Baseline Guidelines

> **Inheritance** — Every agent instruction set extends `CLAUDE.md`, the master specification. Keep this file aligned with Claude and mirror structure/updates across agent-specific briefs.
> **Adaptation** — Apply these expectations by default; other agents may tailor tone or task sizing, but they must not contradict this baseline.

## Project Overview
- **RAPID-AI** delivers a systematic AI-assisted SDLC workflow extracted from the EmberCare healthcare app.
- The framework is task-driven: VS Code tasks trigger shell scripts that coordinate AI tools; the CLI is a secondary convenience.

## Architecture
- Source of truth lives in `src/`, covering the CLI (`src/cli.js`), rapid workflows (`src/rapid/**`), shared helpers (`src/core/**`), adapters (`src/adapters/**`), prompts (`src/prompts/**`), and schemas.
- Distribution artifacts land in `dist/`, generated via build scripts; never edit them directly.
- `src/rapid/**` is the canonical home for conversational workflows, templates, tasks, and knowledge base assets (legacy `.bmad-*` directories were removed in Phase 4).
- `templates/` and `.vscode/` provide reusable task definitions for new projects and for dogfooding.

## Development Commands
- `./scripts/build-dist.sh`, `./scripts/validate-structure.sh`, and `./scripts/install-to-project.sh` manage the source/dist sync.
- `npm run build`, `npm run dev`, `npm test`, and `npm start` support CLI development, watch mode, testing, and runtime verification.

## Critical Patterns
- VS Code tasks (see `templates/vscode/tasks.json`) are the primary interface; ensure problem matchers and input variables remain accurate.
- Shell scripts in `core/scripts/` encapsulate AI orchestration; adapters extend behavior without duplicating core logic.
- Environment detection in `core/workflows/common-functions.sh` adjusts UX for VS Code, Codespaces, or plain terminals.

## Configuration
- `.ai-workflow.yaml` drives project type detection, tool selection, and workflow toggles; keep it kebab-case and validated.
- `src/rapid/rapid-config.yaml` and related configs govern conversational agent behavior; keep them synchronized with the assets in `src/rapid/`.
- YAML schemas in `src/schemas/` enforce structure for generated docs; adjust them alongside related prompts/templates.

## File Structure & Outputs
- Generated discovery/plan/QA docs live in `docs/`; reuse existing subfolders and naming conventions (`story-<epic>-<story>-...`).
- `dist/.vscode/` is the build target shipped into client projects; update via the build pipeline only.
- Core templates and adapters in `templates/`, `examples/`, and `src/adapters/` illustrate how to extend RAPID-AI to other stacks.

## Documentation Workflow Integration
- `core/scripts/task-completion-verification.sh` and related checklists enforce documentation currency before task completion.
- Configuration supports progressive gating (detect → advise → block); default settings favor detection with optional enforcement.
- Adapters map code changes to documentation requirements (e.g., Flutter mapping in `adapters/flutter/config/`).

## Testing Philosophy
- Treat EmberCare production usage as the benchmark: generated analysis must remain technically accurate and resilient.
- Provide explicit architecture validation (schemas, state management, component hierarchy, testing approach) in automation outputs.
- Keep Jest suites colocated with features or in mirrored `__tests__/` directories; stub external CLI calls for determinism.

## Key Constraints & Anti-Patterns
- Preserve POSIX compatibility in shell scripts; avoid TypeScript-based AI integrations.
- Maintain EmberCare backward compatibility, and never reintroduce legacy BMAD branding in the active assets.
- Do not hardcode AI prompts in the CLI; extend adapters or prompt templates instead.
- Favor task-driven workflows over direct CLI invocations unless instrumentation demands otherwise.

## Project Type Detection
- Flutter: `pubspec.yaml`
- React: `package.json` with React deps
- Python: `requirements.txt` or `pyproject.toml`
- Go: `go.mod`
- Default: generic fallback behavior

## Integration Points
- VS Code tasks supply the primary UX; document any task additions or changes.
- Git workflow aligns with Conventional Commits, references relevant stories/checklists, and pairs PRs with test evidence.
- Request reviews from maintainers responsible for the touched subsystems (`src/rapid`, adapters, core tooling, etc.).
