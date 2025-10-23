# RAPID-AI Framework Brownfield Architecture Document

## Introduction

This document captures the **CURRENT STATE** of the RAPID-AI framework codebase, including working patterns, proven implementations, and real-world constraints. It serves as a baseline reference for AI agents working on enhancements and building a **systematic AI-powered Software Development Life Cycle (SDLC) process**.

### Document Scope

**Focused on the complete current system** with special attention to areas relevant to:
- **Primary Goal**: Making VS Code tasks work reliably for AI-powered story analysis
- **Secondary Goal**: Extracting useful workflows/templates from BMAD source material (without branding)
- **Core Purpose**: Building a deliberate, systematic AI-in-SDLC process

### Change Log

| Date | Version | Description | Author |
|------|---------|-------------|--------|
| 2025-10-22 | 1.0 | Initial brownfield analysis for BMAD integration planning | Business Analyst |

## Quick Reference - Key Files and Entry Points

### Critical Files for Understanding the System

- **VS Code Integration**: `templates/vscode/tasks.json` (PRIMARY FOCUS - must work reliably)
- **Core Engine**: `core/scripts/ai-discovery.sh`, `core/scripts/ai-implementation-plan.sh`
- **Framework Functions**: `core/workflows/common-functions.sh` (AI integration, environment detection)
- **Flutter Adapter**: `adapters/flutter/scripts/flutter-discovery.sh` (proven EmberCare implementation)
- **Configuration Template**: `.ai-workflow.yaml` (project configuration)
- **CLI Wrapper**: `src/cli.js` (optional interaction method, secondary priority)
- **Package Definition**: `package.json` (npm distribution)

### Enhancement Impact Areas (Immediate Priorities)

**Phase 1 Target Areas (VS Code Tasks + Systematic SDLC):**
- `templates/vscode/tasks.json` - PRIMARY: ensure tasks work reliably across projects
- `core/workflows/common-functions.sh` - improve AI integration reliability
- `.bmad-core/` directory - EXTRACT useful workflows/templates (remove branding)
- Systematic SDLC process definition (new) - deliberate AI-powered development workflow

**Future Enhancement Areas:**
- `src/cli.js` - CLI wrapper as optional interaction method (not primary focus)
- Multi-AI model support - extending beyond GitHub Copilot
- Dashboard system - simple project status/progress tracking

## High Level Architecture

### Technical Summary

RAPID-AI is a **systematic AI-powered Software Development Life Cycle (SDLC) framework** extracted from the production EmberCare healthcare app. It provides structured, repeatable processes for AI-assisted story analysis and implementation planning, with the primary goal of reliable VS Code task integration.

**Key Architectural Insight**: The framework is primarily a collection of shell scripts with VS Code task integration, not a CLI application. The Node.js CLI wrapper is secondary - an optional interaction method for those who prefer command-line usage.

### Actual Tech Stack (from package.json analysis)

| Category | Technology | Version | Notes |
|----------|------------|---------|-------|
| **Primary Interface** | **VS Code Tasks** | **Built-in** | **Primary user interaction method** |
| Core Engine | Bash/Shell | POSIX | Framework logic for portability |
| AI Integration | GitHub Copilot CLI | External | Primary AI tool (only fully implemented) |
| Configuration | YAML | ^2.3.0 | Project configuration parsing |
| Secondary Interface | Node.js CLI | 18+ | Optional CLI wrapper |
| CLI Framework | Commander | ^11.0.0 | Command-line interface structure |
| User Interaction | Inquirer | ^9.2.0 | Interactive prompts |
| Output Styling | Chalk | ^5.3.0 | Terminal color output |
| Package Manager | npm | Latest | Global and local installation |
| Development | TypeScript | ^5.0.0 | Type safety for CLI development |
| Testing | Jest | ^29.0.0 | Test framework |

### Repository Structure Reality Check

- **Type**: Script collection with VS Code integration (NOT a traditional application)
- **Primary Interface**: VS Code tasks calling shell scripts
- **Secondary Interface**: Optional npm CLI wrapper
- **Distribution**: Shell scripts + task templates + optional CLI package
- **Architecture Pattern**: Task-driven workflow automation

## Source Tree and Module Organization

### Project Structure (Actual)

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

### Key Modules and Their Purpose

- **VS Code Tasks** (`templates/vscode/tasks.json`): PRIMARY user interface - task-driven workflow
- **Core SDLC Scripts** (`core/scripts/`): Portable shell scripts for AI-powered analysis
- **AI Integration Layer** (`core/workflows/common-functions.sh`): Multi-AI abstraction layer
- **Flutter Adapter** (`adapters/flutter/`): Production-proven EmberCare patterns
- **BMAD Source Material** (`.bmad-core/`): Workflows/templates to extract (remove branding)
- **Optional CLI** (`src/cli.js`): Secondary interface for command-line users

## Data Models and APIs

### Configuration Data Model

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

### CLI API Structure

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

### AI Integration API

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

## Technical Debt and Known Issues

### Critical Technical Debt

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

### Workarounds and Gotchas

- **VS Code Task Path Dependencies**: Tasks expect `${workspaceFolder}/ai-dev-workflow/` structure
- **Environment Detection**: Framework adapts progress indicators based on VS Code vs terminal
- **Timeout Protection**: AI calls have 120-second timeout to prevent hanging
- **Shell Script Portability**: POSIX-compatible bash for maximum environment compatibility

### Proven Patterns (Keep These)

- **VS Code Task Integration**: Task-driven workflow is the right primary interface
- **Three-Layer Architecture**: Core → Adapters → Templates pattern works well
- **Shell Script + Node.js Hybrid**: Provides both portability and optional UX
- **Environment-Aware Progress**: Different progress indicators for VS Code vs terminal
- **Flutter Adapter**: EmberCare patterns are production-tested and should be preserved exactly
- **Configuration-Driven**: YAML configuration successfully drives adapter selection

## Integration Points and External Dependencies

### External Services

| Service | Purpose | Integration Type | Key Files |
|---------|---------|------------------|-----------|
| GitHub Copilot CLI | AI story analysis | Command execution | `core/workflows/common-functions.sh` |
| VS Code | Task integration | JSON task definitions | `templates/vscode/tasks.json` |
| npm Registry | Package distribution | npm package | `package.json` |

### Internal Integration Points

- **CLI → Core Scripts**: Node.js commands call bash scripts with standardized arguments
- **Adapter Pattern**: Project type detection routes to appropriate adapter scripts
- **Configuration Loading**: YAML configuration drives behavior across all components
- **Environment Detection**: Framework adapts to VS Code, Codespaces, or terminal environments

### BMAD Source Material Analysis (Extract Without Branding)

**Critical Discovery**: The `.bmad-core/` directory contains systematic SDLC workflows that could be valuable if extracted without BMAD-specific branding and terminology.

**Potentially Useful Components**:
- **Systematic Workflows**: Structured approaches to story creation, validation, architecture
- **Document Templates**: Templates for PRDs, architecture docs, implementation plans  
- **Quality Checklists**: Validation and quality assurance processes
- **Agent Patterns**: Structured role-based approaches to development tasks

**Extraction Approach**: Mine useful systematic processes, strip BMAD branding, integrate into RAPID-AI's direct AI-in-SDLC approach.

## Development and Deployment

### Local Development Setup

**Current Working Setup**:
1. Clone repository: `git clone <repository>`
2. Install dependencies: `npm install`
3. Test CLI locally: `node src/cli.js --help`
4. Test core scripts: `./core/scripts/ai-discovery.sh 1 1 "Test" output.md`

**Prerequisites**:
- Node.js 18+ for CLI development
- GitHub Copilot CLI: `npm install -g @github/copilot`
- VS Code recommended for full integration testing

### Build and Deployment Process

**Current Package Process**:
- **Build Command**: `npm run build` (but no TypeScript source to compile)
- **Distribution**: `npm publish` for global CLI access
- **Files Included**: `dist/`, `core/`, `adapters/`, `templates/`, `README.md`

**Deployment Environments**:
- **Global CLI**: `npm install -g rapid-ai`
- **Project Dependency**: `npm install --save-dev rapid-ai`
- **Direct Usage**: Clone repository and run scripts directly

### Installation Methods

**Framework Installation**:
```bash
# Method 1: Global CLI (intended)
npm install -g rapid-ai

# Method 2: Project dependency
npm install --save-dev rapid-ai

# Method 3: Direct script usage (development)
git clone repository && cd repository
```

**Project Integration**:
```bash
# Initialize in target project
cd target-project
rapid init --type flutter

# Copy VS Code tasks (optional)
cp node_modules/rapid-ai/templates/vscode/tasks.json .vscode/
```

## Testing Reality

### Current Test Coverage

- **Unit Tests**: Minimal coverage with Jest framework configured
- **Integration Tests**: Manual testing with EmberCare as reference implementation
- **Production Validation**: Daily usage in EmberCare development proven the Flutter adapter
- **Cross-Platform**: Tested on macOS (primary), likely works on Linux/Windows

### EmberCare Production Evidence

**Proven Results** (from README):
- ✅ **85-90% Time Reduction**: 2-4 hours → 15-30 minutes per story
- ✅ **100% Architecture Consistency**: Every story follows BLoC/Drift patterns
- ✅ **Technical Accuracy**: AI generates correct Flutter/Dart code 95%+ of the time

**EmberCare Configuration** (production example):
```yaml
project:
  type: "flutter"
  name: "embercare"
  architecture: ["bloc", "drift", "go_router", "get_it"]
custom:
  prd_file: "docs/prd.md"
  theme: "gruvbox_dark"
  primary_platform: "macos"
```

### Running Tests

```bash
npm test               # Run Jest test suite
npm run dev           # Watch mode for CLI development
node src/cli.js --help # Test CLI functionality
```

### Enhancement Impact Analysis (Immediate Priorities)

### Phase 1: VS Code Tasks + Systematic SDLC

**Files That Will Need Modification**:
- `templates/vscode/tasks.json` - **CRITICAL**: Fix path dependencies, improve reliability
- `core/workflows/common-functions.sh` - Improve AI integration reliability  
- Extract from `.bmad-core/` - Mine useful systematic SDLC patterns, strip branding
- Documentation - Focus on systematic AI-in-SDLC process, not BMAD methodology

**New Files/Modules Needed**:
- Systematic SDLC process documentation (without BMAD terminology)
- Improved task reliability mechanisms
- Extracted workflow templates (BMAD content without branding)

### Phase 2: Enhanced AI Integration

**Integration Considerations**:
- Extend AI abstraction layer to support multiple AI tools reliably
- Improve error handling and fallback mechanisms
- Optional CLI wrapper enhancements (secondary priority)

### Phase 3: Advanced Systematic SDLC Features

**Foundation Present**:
- Current task-based integration provides foundation
- Extracted systematic patterns from BMAD source material
- Proven EmberCare implementation patterns

## Technical Constraints for Enhancement

### Must Preserve

1. **EmberCare Compatibility**: All existing functionality must continue working
2. **VS Code Task Priority**: Task-based interface is primary, must be reliable
3. **Shell Script Portability**: Core logic must remain in portable bash scripts
4. **Three-Layer Architecture**: Core → Adapters → Templates pattern is proven

### Enhancement Opportunities

1. **VS Code Task Reliability**: Fix path dependencies and improve error handling (**CRITICAL**)
2. **Systematic SDLC Extraction**: Mine `.bmad-core/` for useful patterns, strip BMAD branding
3. **Multi-AI Support**: Abstraction layer exists, just needs implementation (secondary)
4. **Optional CLI Enhancement**: Improve CLI wrapper as secondary interface (low priority)

### Integration Guidelines

- **Primary Focus**: VS Code tasks must work reliably across all projects
- **Systematic SDLC**: Extract useful BMAD patterns without the methodology branding
- **AI Integration**: Build on existing abstraction layer for multi-AI support
- **Compatibility**: All enhancements must maintain backward compatibility with EmberCare

## Appendix - Useful Commands and Scripts

### Framework Development Commands

```bash
# VS Code Task Testing (PRIMARY)
# Test in VS Code Command Palette:
# - AI Workflow: Analyze Story
# - AI Workflow: Generate Implementation Plan
# - AI Workflow: Flutter Analysis

# Core Framework Testing
./core/scripts/ai-discovery.sh 1 1 "Test Story" test-output.md
./adapters/flutter/scripts/flutter-discovery.sh 1 1 "Flutter Test" flutter-output.md

# BMAD Source Material Exploration (for extraction)
npm run bmad:list      # See available workflows/templates to extract
npm run bmad:validate  # Understand BMAD structure for extraction

# Optional CLI Development (secondary)
npm run build          # Compile TypeScript (when implemented)
npm run dev            # Watch mode for development
npm test               # Run test suite
```

### VS Code Integration Testing

```bash
# Test VS Code tasks (in VS Code Command Palette)
AI Workflow: Analyze Story
AI Workflow: Generate Implementation Plan
AI Workflow: Flutter Analysis
AI Workflow: Complete Story Setup
```

### Common Issues and Solutions

- **VS Code Tasks Not Working**: Check path dependencies in `tasks.json` (**CRITICAL ISSUE**)
- **Copilot CLI Not Found**: Install with `npm install -g @github/copilot`
- **Permission Issues**: Ensure shell scripts have execute permissions
- **Timeout Issues**: Increase timeout in configuration if AI calls take longer
- **BMAD Content Confusion**: Focus on extracting systematic patterns, not implementing BMAD methodology

---

**Next Steps**: This brownfield architecture document provides the foundation for building a systematic AI-powered SDLC process with reliable VS Code task integration as the primary interface.

**Key Insight**: The focus should be on making VS Code tasks work reliably and extracting useful systematic SDLC patterns from the BMAD source material, not implementing the BMAD methodology itself.