# High Level Architecture

## Technical Summary

RAPID-AI is a **systematic AI-powered Software Development Life Cycle (SDLC) framework** extracted from the production EmberCare healthcare app. It provides structured, repeatable processes for AI-assisted story analysis and implementation planning, with the primary goal of reliable VS Code task integration.

**Key Architectural Insight**: The framework is primarily a collection of shell scripts with VS Code task integration, not a CLI application. The Node.js CLI wrapper is secondary - an optional interaction method for those who prefer command-line usage.

## Actual Tech Stack (from package.json analysis)

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

## Repository Structure Reality Check

- **Type**: Script collection with VS Code integration (NOT a traditional application)
- **Primary Interface**: VS Code tasks calling shell scripts
- **Secondary Interface**: Optional npm CLI wrapper
- **Distribution**: Shell scripts + task templates + optional CLI package
- **Architecture Pattern**: Task-driven workflow automation
