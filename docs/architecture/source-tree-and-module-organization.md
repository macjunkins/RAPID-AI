# Source Tree and Module Organization

## Project Structure (Actual)

```text
RAPID-AI/
├── **src/**                          # **SOURCE OF TRUTH**
│   ├── **core/**                     # Execution workflows and shared scripts
│   │   ├── scripts/                  # AI-enabled shell tooling
│   │   └── workflows/                # Common orchestration helpers
│   ├── **rapid/**                    # Conversational workflows (agents, tasks, templates, data)
│   ├── **adapters/**                 # Project-type specific extensions (Flutter, etc.)
│   ├── **prompts/**                  # Prompt templates for automation
│   └── **schemas/**                  # YAML schemas for validation
├── **dist/.vscode/**                 # Distribution bundle generated from `src/`
├── **templates/**                    # Example VS Code tasks and starter assets
├── **docs/**                         # Project documentation, PRDs, stories, architecture notes
├── **scripts/**                      # Build, validation, and install scripts
├── .ai-workflow.yaml                 # Default workflow configuration
├── package.json                      # npm metadata (CLI distribution planned for later phase)
└── README.md                         # Framework documentation
```

## Key Modules and Their Purpose

- **VS Code Tasks** (`dist/.vscode/tasks.json` & `templates/vscode/tasks.json`): Task-driven primary interface
- **Core SDLC Scripts** (`src/core/scripts/`): Portable shell scripts for AI-powered analysis
- **AI Integration Layer** (`src/core/workflows/common-functions.sh`): Multi-AI abstraction layer
- **RAPID Conversational Framework** (`src/rapid/**`): Agents, tasks, templates, data, workflows
- **Adapters** (`src/adapters/`): Project-type extensions (Flutter today; more coming)
- **Optional CLI Wrapper** (`src/cli.js`): Secondary interface for later phases
