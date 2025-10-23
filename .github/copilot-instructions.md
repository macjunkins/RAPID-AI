````instructions
# RAPID-AI Framework - AI Coding Agent Instructions

## Project Overview
RAPID-AI is a **systematic AI-powered SDLC framework** extracted from the production EmberCare healthcare app. It provides structured, repeatable processes for AI-assisted story analysis and implementation planning, with **VS Code tasks as the primary interface**.

## Core Architecture

### Three-Layer Design + BMAD Integration
1. **Core Framework** (`core/`): Language-agnostic shell scripts and AI integration
2. **Adapters** (`adapters/`): Project-specific implementations (Flutter proven from EmberCare)  
3. **Templates & Examples** (`templates/`, `examples/`): VS Code tasks and reusable configurations
4. **BMAD Method Integration** (`.bmad-core/`): Extracted agent workflows and structured development processes

### Critical Insight: Task-Driven, Not CLI-Driven
- **Primary Interface**: VS Code tasks in `templates/vscode/tasks.json` calling shell scripts
- **Secondary Interface**: Optional CLI wrapper in `src/cli.js` for command-line users
- **Core Logic**: Bash scripts in `core/scripts/` for maximum portability
- **Architecture**: Task-driven workflow automation, not a traditional application

## Essential Patterns

### VS Code Tasks Integration (Primary Interface)
```jsonc
// templates/vscode/tasks.json - Main user interface
{
    "label": "AI Workflow: Analyze Story",
    "command": "${workspaceFolder}/core/scripts/ai-discovery.sh",
    "args": ["${input:epic}", "${input:story}", "${input:title}", "output.md"],
    "problemMatcher": {
        "pattern": [{"regexp": "^❌\\s+(.+)$", "message": 1}]
    }
}
```
**Key**: Tasks provide parameterized inputs and error detection. Problem matchers catch AI workflow errors.

### AI Integration Flow (core/workflows/common-functions.sh)
```bash
# AI tools abstracted through run_ai_analysis()
case "$tool" in
    "copilot") timeout ${timeout}s copilot -p "$prompt" > "$temp_output" ;;
    "claude") timeout ${timeout}s claude_api_call "$prompt" > "$temp_output" ;;
```
**Key**: Only GitHub Copilot CLI fully implemented. Claude/GPT4 are stubs for future expansion.

### Environment-Aware Progress (core/workflows/common-functions.sh)
```bash
detect_environment() {
    if [ "$TERM_PROGRAM" = "vscode" ]; then echo "vscode"
    elif [ -n "$CODESPACES" ]; then echo "codespaces"
    else echo "terminal"; fi
}
```
**Pattern**: Adapts progress indicators and file opening behavior per environment. VS Code gets enhanced feedback.

### Project-Specific Prompts (adapters/flutter/scripts/flutter-discovery.sh)
```bash
# EmberCare production-tested prompt pattern
local prompt="Read docs/prd.md and find Story $epic.$story: $title.
For this Flutter story using BLoC + Drift architecture, provide:
1. **Story Requirements Summary** ..."
```
**Pattern**: Each adapter customizes AI prompts for specific architecture patterns.

## Critical Integration Points

### Configuration-Driven Behavior (.ai-workflow.yaml)
```yaml
project:
  type: "flutter"  # Determines which adapter to use
  architecture: ["bloc", "drift"]  # Passed to AI prompts
ai_tools: ["copilot"]  # Tool selection
workflows:
  story_analysis:
    enabled: true
    timeout: 120
    outputs: ["docs/discovery/{epic}-{story}-discovery.md"]
```

### VS Code Tasks Integration
- Framework provides `templates/vscode/tasks.json` with parameterized inputs
- Tasks call framework scripts directly: `${workspaceFolder}/core/scripts/ai-discovery.sh`
- Problem matchers detect AI workflow errors: `"❌\\s+(.+)$"`
- Input variables: `${input:epic}`, `${input:story}`, `${input:title}` for interactive prompts

### BMAD Method Integration  
- Project includes BMAD agent definitions in `AGENTS.md` (auto-generated from `.bmad-core/`)
- BMAD provides structured agent roles (dev, architect, pm, etc.) for AI-powered development
- CLI scripts bridge BMAD methodology with AI tools: `npm run bmad:refresh`
- Extract workflows/templates from `.bmad-core/` without branding

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

### CLI Usage
```bash
npx rapid init --type flutter --ai copilot
npx rapid analyze 1 4 "User Authentication"
npx rapid plan 1 4 "User Authentication"
```

### VS Code Task Usage (Primary Interface)
- Open Command Palette: `Cmd+Shift+P` (macOS) / `Ctrl+Shift+P` (Windows/Linux)
- Search for: "Tasks: Run Task"
- Select: "AI Workflow: Analyze Story", "AI Workflow: Complete Story Setup", etc.
- Input prompts will ask for epic number, story number, and title

## File Creation Patterns

### Discovery Documents
Generated in `docs/discovery/story-{epic}-{story}-discovery.md` with:
- AI analysis metadata (tool, date, status)
- Project-specific technical guidance (Drift schemas for Flutter, component specs for React)
- Implementation file lists with exact paths
- Testing strategies appropriate to the architecture

### Configuration Templates
- `.ai-workflow.yaml` drives project type detection and AI prompt customization
- `pubspec.yaml` presence → Flutter adapter
- `package.json` with React deps → React adapter (planned)

### BMAD Integration Outputs
- `.bmad-core/agents/` → Extracted agent definitions  
- `.bmad-core/tasks/` → Reusable workflow tasks
- `.bmad-core/templates/` → Document templates
- `AGENTS.md` → Auto-generated agent summaries for Copilot consumption

## Testing Philosophy

### Proven in Production (EmberCare)
- Framework generates technically accurate Flutter/Dart/BLoC code
- AI analysis matches actual implementation patterns 95%+ of the time
- Fallback templates prevent blocking when AI fails

### Architecture Validation
Generated analysis must include:
- Database schema definitions (Drift tables for Flutter)
- State management patterns (BLoC events/states for Flutter)  
- Component hierarchies with specific file paths
- Testing approaches (bloc_test, flutter_test, mocktail)

## Key Constraints

### Shell Script Portability
- All core logic in POSIX-compatible bash for maximum compatibility
- Environment detection handles VS Code, Codespaces, terminal differences
- Timeout protection prevents hanging on AI calls

### AI Tool Abstraction  
- Only GitHub Copilot CLI fully implemented (`copilot -p "prompt"`)
- Claude/OpenAI are placeholder functions for future implementation
- Framework structure supports multiple tools but current focus is Copilot

### BMAD Method Constraints
- Extract workflows/templates from `.bmad-core/` without BMAD branding
- Maintain compatibility with existing BMAD structure during extraction
- Focus on systematic SDLC processes rather than specific methodology

### EmberCare Backward Compatibility
Framework extraction maintains 100% compatibility with existing EmberCare scripts - they become thin wrappers calling the framework.

## Anti-Patterns to Avoid

❌ Don't hardcode AI prompts in CLI code - use adapter scripts  
❌ Don't assume npm/Node.js in core scripts - they run in any shell  
❌ Don't break EmberCare compatibility - it's the proven reference implementation  
❌ Don't implement AI integrations in TypeScript - shell scripts are more portable
❌ Don't modify BMAD branding in extracted content - remove it cleanly
❌ Don't bypass VS Code tasks as primary interface - CLI is secondary convenience