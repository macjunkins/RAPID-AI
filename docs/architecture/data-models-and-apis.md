# Data Models and APIs

## Configuration Data Model

**Primary Configuration**: `.ai-workflow.yaml`
```yaml
project:
  type: "flutter|react|python|go|generic"
  architecture: ["bloc", "drift"] # project-specific patterns

ai_tools:
  - "copilot"  # Only copilot fully implemented

workflows:
  story_analysis:
    enabled: true
    timeout: 120

integrations:
  vscode: { enabled: true, auto_open_files: true }
  git: { auto_branch: true, branch_pattern: "story/{epic}-{story}-{slug}" }
```

## VS Code Tasks API

**Primary Interface**: VS Code tasks in `templates/vscode/tasks.json`
- "AI Workflow: Analyze Story" - Run story analysis via tasks
- "AI Workflow: Generate Implementation Plan" - Create implementation plan
- "AI Workflow: Flutter Analysis" - Flutter-specific analysis
- "AI Workflow: Complete Story Setup" - Full workflow sequence

## Shell Script APIs

**Core discovery**:
```bash
./core/scripts/ai-discovery.sh <epic> <story> <title> <output-file>
./core/scripts/ai-implementation-plan.sh <epic> <story> <title> <discovery-file> <output-file>
```

## AI Integration API

**Abstraction Layer** (`core/workflows/common-functions.sh`):
```bash
run_ai_analysis() {
    case "$tool" in
        "copilot") timeout ${timeout}s copilot -p "$prompt" > "$temp_output" ;;
        "claude") timeout ${timeout}s claude_api_call "$prompt" > "$temp_output" ;;
    esac
}
```

**Critical Constraint**: Only GitHub Copilot CLI is fully implemented. Claude and GPT-4 are placeholder functions.

## Configuration Data Model

**Primary Configuration**: `.ai-workflow.yaml`
```yaml
project:
  type: "flutter|react|python|go|generic"
  name: "project-name"
  architecture: ["bloc", "drift"] # project-specific patterns

ai_tools:
  - "copilot"  # Only copilot fully implemented

workflows:
  story_analysis:
    enabled: true
    timeout: 120
    outputs: ["discovery/", "plans/"]

integrations:
  vscode: { enabled: true, auto_open_files: true }
  git: { auto_branch: true, branch_pattern: "story/{epic}-{story}-{slug}" }
```

## CLI API Structure

**VS Code Tasks** (primary interface):
- "AI Workflow: Analyze Story" - Run story analysis via tasks
- "AI Workflow: Generate Implementation Plan" - Create implementation plan
- "AI Workflow: Flutter Analysis" - Flutter-specific analysis
- "AI Workflow: Complete Story Setup" - Full workflow sequence

**Shell Script APIs** (core functionality):
```bash
# Core discovery
./core/scripts/ai-discovery.sh <epic> <story> <title> <output-file>

# Implementation planning
./core/scripts/ai-implementation-plan.sh <epic> <story> <title> <discovery-file> <output-file>

**Optional CLI Commands** (secondary interface):
- `rapid init --type <project-type> --ai <tool>` - Initialize AI workflow  
- `rapid analyze <epic> <story> <title>` - Run story analysis
- `rapid plan <epic> <story> <title>` - Generate implementation plan

## AI Integration API

**Abstraction Layer** (`common-functions.sh`):
```bash
run_ai_analysis() {
    case "$tool" in
        "copilot") timeout ${timeout}s copilot -p "$prompt" > "$temp_output" ;;
        "claude") timeout ${timeout}s claude_api_call "$prompt" > "$temp_output" ;;  # STUB
        "gpt4") timeout ${timeout}s openai_api_call "$prompt" > "$temp_output" ;;    # STUB
    esac
}
```

**Critical Constraint**: Only GitHub Copilot CLI is fully implemented. Claude and GPT-4 are placeholder functions.

# Technical Debt and Known Issues

## Critical Technical Debt

1. **VS Code Task Reliability Issues**: Tasks sometimes fail due to path dependencies
   - Impact: Primary user interface is unreliable
   - Location: `templates/vscode/tasks.json`
   - Enhancement Priority: **CRITICAL** - this is the main user interface

2. **AI Tool Implementation**: Only GitHub Copilot CLI works - Claude/GPT-4 are stubs
   - Impact: Limits multi-AI capabilities mentioned in roadmap
   - Location: `core/workflows/common-functions.sh`
   - Enhancement Priority: Medium (after VS Code tasks work)
3. **BMAD Content Extraction Needed**: `.bmad-core/` contains useful workflows but with BMAD branding
   - Impact: Good systematic SDLC patterns buried in BMAD-specific terminology
   - Location: `.bmad-core/` directory
   - Enhancement Priority: High - extract workflows, remove BMAD branding/fluff

4. **CLI Package Distribution**: Package name mismatch (`rapid-ai` vs `ai-dev-workflow`)
   - Impact: Confusion in documentation and installation instructions
   - Files: `package.json`, `README.md`, installation docs
   - Enhancement Priority: Low (CLI is secondary interface)

5. **Missing TypeScript Compilation**: CLI source is `.js` but TypeScript is in devDependencies
   - Impact: Type safety not enforced, no compilation step
   - Location: `src/cli.js` should be `.ts` with build process
   - Build Command: `npm run build` exists but no TypeScript source

## Workarounds and Gotchas

- **VS Code Task Path Dependencies**: Tasks expect `${workspaceFolder}/ai-dev-workflow/` structure
- **Environment Detection**: Framework adapts progress indicators based on VS Code vs terminal
- **Timeout Protection**: AI calls have 120-second timeout to prevent hanging
- **Shell Script Portability**: POSIX-compatible bash for maximum environment compatibility

## Proven Patterns (Keep These)

- **VS Code Task Integration**: Task-driven workflow is the right primary interface
- **Three-Layer Architecture**: Core → Adapters → Templates pattern works well
- **Shell Script + Node.js Hybrid**: Provides both portability and optional UX
- **Environment-Aware Progress**: Different progress indicators for VS Code vs terminal
- **Flutter Adapter**: EmberCare patterns are production-tested and should be preserved exactly
- **Configuration-Driven**: YAML configuration successfully drives adapter selection

# Integration Points and External Dependencies

## External Services

| Service | Purpose | Integration Type | Key Files |
|---------|---------|------------------|-----------|
| GitHub Copilot CLI | AI story analysis | Command execution | `core/workflows/common-functions.sh` |
| VS Code | Task integration | JSON task definitions | `templates/vscode/tasks.json` |
| npm Registry | Package distribution | npm package | `package.json` |

## Internal Integration Points

- **CLI → Core Scripts**: Node.js commands call bash scripts with standardized arguments
- **Adapter Pattern**: Project type detection routes to appropriate adapter scripts
- **Configuration Loading**: YAML configuration drives behavior across all components
- **Environment Detection**: Framework adapts to VS Code, Codespaces, or terminal environments

## BMAD Source Material Analysis (Extract Without Branding)

**Critical Discovery**: The `.bmad-core/` directory contains systematic SDLC workflows that could be valuable if extracted without BMAD-specific branding and terminology.

**Potentially Useful Components**:
- **Systematic Workflows**: Structured approaches to story creation, validation, architecture
- **Document Templates**: Templates for PRDs, architecture docs, implementation plans  
- **Quality Checklists**: Validation and quality assurance processes
- **Agent Patterns**: Structured role-based approaches to development tasks

**Extraction Approach**: Mine useful systematic processes, strip BMAD branding, integrate into RAPID-AI's direct AI-in-SDLC approach.

# Development and Deployment

## Local Development Setup

**Current Working Setup**:
1. Clone repository: `git clone <repository>`
2. Install dependencies: `npm install`
3. Test CLI locally: `node src/cli.js --help`
4. Test core scripts: `./core/scripts/ai-discovery.sh 1 1 "Test" output.md`

**Prerequisites**:
- Node.js 18+ for CLI development
- GitHub Copilot CLI: `npm install -g @github/copilot`
- VS Code recommended for full integration testing

## Build and Deployment Process

**Current Package Process**:
- **Build Command**: `npm run build` (but no TypeScript source to compile)
- **Distribution**: `npm publish` for global CLI access
- **Files Included**: `dist/`, `core/`, `adapters/`, `templates/`, `README.md`

**Deployment Environments**:
- **Global CLI**: `npm install -g rapid-ai`
- **Project Dependency**: `npm install --save-dev rapid-ai`
- **Direct Usage**: Clone repository and run scripts directly

## Installation Methods

**Framework Installation**:
```bash