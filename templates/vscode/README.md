# RAPID-AI VS Code Bundle

Self-contained RAPID-AI workflows designed to live inside `.vscode/` for any project. Copy this directory into a target repository to unlock both conversational and execution modes with zero additional setup.

## Quick Start

```bash
# From RAPID-AI root
./scripts/build-dist.sh

# Install into another project
./scripts/install-to-project.sh /path/to/project
```

Inside the target project:

1. Open VS Code.
2. Run `Tasks: Run Task`.
3. Choose any `RAPID:` task below.

## Conversational Tasks

These tasks surface ready-to-run commands for the RAPID conversational agent (`/rapid`) in the Claude CLI.

- **RAPID: Conversational Mode - Instructions** — Step-by-step overview for launching `/rapid` and running workflows.
- **RAPID: Create Document** — Generates `/rapid:create-doc <template>` command with your chosen template id.
- **RAPID: Execute Task** — Generates `*task <slug>` command for any workflow task.
- **RAPID: Run Checklist** — Generates `*execute-checklist <slug>` for quality validation runs.

> Templates, tasks, and checklists live under `src/rapid/{templates,tasks,checklists}`. Use the prompts when running tasks to pick the ids you need.

## Execution Tasks

- **RAPID: Generate Story from Epic** — Calls `.vscode/core/scripts/generate-story-yaml.sh` to build story YAML from Claude CLI.
- **RAPID: Test Claude CLI** — Verifies the Claude CLI is installed.
- **RAPID: Validate YAML Files** — Runs `yq` across `docs/**/*.yaml`.
- **RAPID: Query All Stories** — Prints story ids, titles, and status from `docs/stories/`.
- **RAPID: Show Epic Summary** — Summarises an epic from `docs/prd/epic-<n>.yaml`.

## File Layout

```
.vscode/
├── tasks.json              # This task file
├── README.md               # Quick reference (this document)
├── core/                   # Execution framework
├── rapid/                  # Conversational workflow assets
├── adapters/               # Optional project adapters
└── prompts/, schemas/      # Prompt templates and YAML schemas
```

## Tips

- Tasks print commands but do not run the conversational session for you. Copy the generated command into Claude after launching `/rapid`.
- Rebuild whenever `src/**` changes: `./scripts/build-dist.sh && cp -r dist/.vscode/* .vscode/`.
- Need to automate additional workflows? Extend `src/core/scripts/` or add new tasks in this directory, then rebuild the dist bundle.
