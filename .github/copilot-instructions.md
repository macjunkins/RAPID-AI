# RAPID-AI Framework - AI Coding Agent Instructions

## Project Overview
RAPID-AI is a **framework for AI-powered development workflows** extracted from the production EmberCare healthcare app. It automates story analysis and implementation planning with 85-90% time reduction proven in production.

## Core Architecture

### Three-Layer Design
1. **Core Framework** (`core/`): Language-agnostic shell scripts and AI integration
2. **Adapters** (`adapters/`): Project-specific implementations (Flutter proven, React/Python/Go planned)  
3. **Templates & Examples** (`templates/`, `examples/`): Reusable configurations and real-world usage

### Key Insight: Framework vs CLI
- `core/scripts/` = Bash framework that does the actual AI integration work
- `src/cli.js` = Node.js wrapper for better UX and npm distribution
- Most logic lives in shell scripts for portability across environments

## Essential Patterns

### AI Integration Flow (core/workflows/common-functions.sh)
```bash
# AI tools are abstracted through run_ai_analysis()
case "$tool" in
    "copilot") timeout ${timeout}s copilot -p "$prompt" > "$temp_output" ;;
    "claude") timeout ${timeout}s claude_api_call "$prompt" > "$temp_output" ;;
```
**Key**: Framework supports multiple AI tools but only GitHub Copilot CLI is implemented. Claude/GPT4 are stubs.

### Project-Specific Prompts (adapters/flutter/scripts/flutter-discovery.sh)
```bash
# This exact prompt pattern works for EmberCare production
local prompt="Read docs/prd.md and find Story $epic.$story: $title.
For this Flutter story using BLoC + Drift architecture, provide:
1. **Story Requirements Summary** ..."
```
**Pattern**: Each adapter customizes AI prompts for architecture (BLoC+Drift for Flutter).

### Configuration-Driven Behavior (.ai-workflow.yaml)
```yaml
project:
  type: "flutter"  # Determines which adapter to use
  architecture: ["bloc", "drift"]  # Passed to AI prompts
ai_tools: ["copilot"]  # Tool selection
```

## Critical Integration Points

### VS Code Tasks Integration
- Framework provides `templates/vscode/tasks.json` with parameterized inputs
- Tasks call framework scripts directly: `${workspaceFolder}/ai-dev-workflow/core/scripts/ai-discovery.sh`
- Problem matchers detect AI workflow errors: `"❌\\s+(.+)$"`

### BMAD Method Integration  
- Project includes BMAD agent definitions in `AGENTS.md` (auto-generated)
- BMAD provides structured agent roles (dev, architect, pm, etc.) for AI-powered development
- CLI scripts bridge BMAD methodology with AI tools: `npm run bmad:refresh`

### Environment Detection (common-functions.sh)
```bash
detect_environment() {
    if [ "$TERM_PROGRAM" = "vscode" ]; then echo "vscode"
    elif [ -n "$CODESPACES" ]; then echo "codespaces"
    else echo "terminal"; fi
}
```
**Purpose**: Adapts progress indicators and file opening behavior per environment.

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

### EmberCare Backward Compatibility
Framework extraction maintains 100% compatibility with existing EmberCare scripts - they become thin wrappers calling the framework.

## Anti-Patterns to Avoid

❌ Don't hardcode AI prompts in CLI code - use adapter scripts  
❌ Don't assume npm/Node.js in core scripts - they run in any shell  
❌ Don't break EmberCare compatibility - it's the proven reference implementation  
❌ Don't implement AI integrations in TypeScript - shell scripts are more portable