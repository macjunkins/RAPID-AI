# Technical Constraints and Integration Requirements

## Existing Technology Stack

**From brownfield architecture analysis:**

| Category | Technology | Version | Notes |
|----------|------------|---------|-------|
| **Primary Interface** | **VS Code Tasks** | **Built-in** | **Primary user interaction method** |
| Core Engine | Bash/Shell | POSIX | Framework logic for portability |
| AI Integration | GitHub Copilot CLI | External | Primary AI tool (only fully implemented) |
| Configuration | YAML | ^2.3.0 | Project configuration parsing |
| Secondary Interface | Node.js CLI | 18+ | Optional CLI wrapper |
| Package Manager | npm | Latest | Global and local installation |
| Development | TypeScript | ^5.0.0 | Type safety for CLI development |

## Integration Approach

**VS Code Task Integration Strategy**: Fix path dependencies in `templates/vscode/tasks.json`, improve error handling, ensure tasks work reliably across project structures without requiring specific directory layouts

**BMAD Source Material Integration Strategy**: Extract systematic workflows from `.bmad-core/` directory, remove BMAD-specific branding and terminology, integrate useful patterns into RAPID-AI's direct AI-in-SDLC approach

**AI Integration Strategy**: Enhance existing abstraction layer in `core/workflows/common-functions.sh` to support multiple AI tools while maintaining current GitHub Copilot functionality

**Configuration Integration Strategy**: Extend existing YAML configuration system to support systematic SDLC settings while maintaining backward compatibility

## Code Organization and Standards

**File Structure Approach**: Maintain three-layer architecture (Core → Adapters → Templates) while adding systematic SDLC components extracted from BMAD source material

**Naming Conventions**: Follow existing shell script naming, preserve EmberCare adapter patterns, use clear systematic naming for extracted SDLC workflows

**Coding Standards**: Maintain POSIX-compatible shell scripts for portability, environment detection patterns, timeout protection for AI calls

**Documentation Standards**: Create clear, actionable documentation free of methodology-specific terminology, focus on practical AI-in-SDLC processes

## Deployment and Operations

**Build Process Integration**: Enhance existing npm package structure to include systematic SDLC components, maintain shell script + Node.js CLI hybrid approach

**Deployment Strategy**: Support both global npm installation and project-specific integration, maintain VS Code task template distribution

**Monitoring and Logging**: Enhance existing progress indicators and error reporting for systematic SDLC processes

**Configuration Management**: Extend YAML configuration system for systematic SDLC settings while preserving EmberCare compatibility

## Risk Assessment and Mitigation

**From brownfield architecture analysis - Critical Technical Debt:**

**Technical Risks**: 
- VS Code task path dependencies could break existing workflows
- BMAD extraction might introduce complexity without value
- Shell script changes could affect EmberCare production usage

**Integration Risks**:
- Systematic SDLC processes might conflict with existing adapter patterns  
- Configuration changes could break existing EmberCare setup
- AI integration modifications might affect proven Copilot functionality

**Deployment Risks**:
- Package distribution changes could affect global CLI installation
- VS Code task modifications might not work across different VS Code versions

**Mitigation Strategies**:
- Maintain strict backward compatibility testing with EmberCare patterns
- Implement systematic SDLC features as additive enhancements, not replacements
- Use feature flags for new systematic SDLC capabilities
- Preserve existing shell script interfaces exactly
