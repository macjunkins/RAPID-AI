# Source Tree and Module Organization

## Project Structure (Actual)

```text
RAPID-AI/
├── **templates/vscode/**               # **PRIMARY: VS Code task integration**
│   └── tasks.json                    # **Task definitions (main user interface)**
├── **core/**                         # **Core SDLC automation scripts**
│   ├── scripts/                      # AI-powered analysis scripts
│   │   ├── ai-discovery.sh           # Story analysis (proven)
│   │   └── ai-implementation-plan.sh # Implementation planning
│   └── workflows/                    # Shared utilities
│       └── common-functions.sh       # AI integration, env detection
├── **adapters/**                     # **Project-type specific logic**
│   └── flutter/                      # Flutter + BLoC + Drift (EmberCare proven)
│       └── scripts/
│           └── flutter-discovery.sh  # Production-tested patterns
├── **.bmad-core/**                   # **Source material for workflow extraction**
│   ├── agents/                       # Extract useful agent patterns
│   ├── tasks/                        # Extract workflow tasks
│   └── templates/                    # Extract document templates
├── **src/**                          # **Optional CLI wrapper (secondary)**
│   └── cli.js                        # Command-line interface wrapper
├── examples/                         # Integration examples
│   └── embercare/                    # Real-world usage documentation
├── .ai-workflow.yaml                # Configuration template
├── package.json                     # npm package configuration
└── README.md                        # Framework documentation
```

## Key Modules and Their Purpose

- **VS Code Tasks** (`templates/vscode/tasks.json`): PRIMARY user interface - task-driven workflow
- **Core SDLC Scripts** (`core/scripts/`): Portable shell scripts for AI-powered analysis
- **AI Integration Layer** (`core/workflows/common-functions.sh`): Multi-AI abstraction layer
- **Flutter Adapter** (`adapters/flutter/`): Production-proven EmberCare patterns
- **BMAD Source Material** (`.bmad-core/`): Workflows/templates to extract (remove branding)
- **Optional CLI** (`src/cli.js`): Secondary interface for command-line users
