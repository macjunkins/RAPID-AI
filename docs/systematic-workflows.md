# Systematic SDLC Workflows

## Overview

RAPID-AI includes systematic workflow patterns extracted from proven SDLC methodologies, adapted for direct AI-powered development integration. These workflows enhance existing AI analysis capabilities with structured, repeatable processes.

## Available Systematic Workflows

### 1. Project Analysis Workflow

**Purpose:** Analyze existing projects to generate comprehensive documentation for AI-powered development.

**VS Code Task:** `Systematic: Project Analysis`

**Manual Execution:**
```bash
./core/workflows/systematic/project-analysis.sh
```

**What it does:**
- Analyzes project directory structure
- Identifies technology stack from configuration files
- Generates brownfield architecture documentation
- Creates foundation for AI-powered enhancements

**Output Files:**
- `docs/project-structure-analysis.md` - Directory structure and key files
- `docs/tech-stack-analysis.md` - Technology stack identification
- `docs/brownfield-architecture.md` - Comprehensive project documentation

### 2. Quality Checklist Workflow

**Purpose:** Systematic quality assurance through interactive checklists.

**VS Code Task:** `Systematic: Quality Checklist`

**Manual Execution:**
```bash
./core/workflows/systematic/quality-checklist.sh [generate|interactive|analyze]
```

**Modes:**
- `generate` - Create new quality checklist template
- `interactive` - Run interactive checklist review (default)
- `analyze` - Analyze existing checklist completion

**What it does:**
- Generates comprehensive quality checklist
- Provides interactive review process
- Analyzes completion status
- Opens checklist in VS Code for editing

**Output Files:**
- `docs/quality-checklist.md` - Quality assurance checklist

### 3. Document Generator Workflow

**Purpose:** Generate structured documents from templates with variable substitution.

**VS Code Tasks:** 
- `Systematic: Generate Document` (interactive)
- `Systematic: Generate Story Document` (batch)

**Manual Execution:**
```bash
# Interactive mode
./core/workflows/systematic/document-generator.sh interactive

# Batch mode
./core/workflows/systematic/document-generator.sh batch <template> <output> [variables]

# List templates
./core/workflows/systematic/document-generator.sh list
```

**What it does:**
- Lists available document templates
- Prompts for template variables
- Generates documents with variable substitution
- Supports both interactive and batch modes

**Available Templates:**
- `story-template` - User story document template

## Configuration

Systematic workflows are configured in `.ai-workflow.yaml`:

```yaml
systematic:
  enabled: true  # Enable systematic SDLC workflows
  workflows:
    project_analysis:
      enabled: true
      auto_run: false  # Run on demand
      outputs:
        - "docs/project-structure-analysis.md"
        - "docs/tech-stack-analysis.md"
        - "docs/brownfield-architecture.md"
    
    quality_checklist:
      enabled: true
      auto_generate: true  # Auto-generate checklist for each story
      interactive_mode: true
      
    document_generation:
      enabled: true
      templates_dir: "core/workflows/systematic/templates"
      output_dir: "docs"
```

## Integration with Existing Workflows

Systematic workflows **enhance** rather than replace existing AI-powered workflows:

### Complementary Usage

1. **Project Setup Phase:**
   - Run `Systematic: Project Analysis` to understand existing codebase
   - Use results to inform AI story analysis

2. **Story Development:**
   - Use existing `AI Workflow: Analyze Story` for AI-powered analysis
   - Use `Systematic: Generate Story Document` for structured documentation
   - Apply `Systematic: Quality Checklist` before marking stories complete

3. **Quality Assurance:**
   - Existing AI workflows provide technical analysis
   - Systematic quality checklist ensures systematic review

### Workflow Combination Examples

**New Project Analysis:**
```bash
# 1. Systematic project analysis
./core/workflows/systematic/project-analysis.sh

# 2. AI-powered story analysis using project context
./core/scripts/ai-discovery.sh 1 1 "Feature Name" output.md
```

**Story Development with Quality Assurance:**
```bash
# 1. Generate story document from template
./core/workflows/systematic/document-generator.sh batch story-template story-1-1

# 2. AI analysis of story requirements  
./core/scripts/ai-discovery.sh 1 1 "Feature Name" discovery.md

# 3. Quality checklist review
./core/workflows/systematic/quality-checklist.sh interactive
```

## VS Code Integration

All systematic workflows are available through VS Code tasks:

1. **Open Command Palette:** `Cmd+Shift+P` (macOS) / `Ctrl+Shift+P` (Windows/Linux)
2. **Search:** "Tasks: Run Task"
3. **Select systematic workflow:**
   - `Systematic: Project Analysis`
   - `Systematic: Quality Checklist`
   - `Systematic: Generate Document`
   - `Systematic: Generate Story Document`

## Benefits

### Enhanced Structure
- Systematic processes complement AI analysis
- Repeatable quality assurance procedures
- Structured document generation

### Maintained Flexibility
- AI workflows remain primary interface
- Systematic workflows available on-demand
- No methodology overhead or complex frameworks

### Proven Patterns
- Extracted from production-tested methodologies
- Adapted for direct AI integration
- Focus on practical, executable components

## Best Practices

1. **Use Complementary to AI Workflows**
   - Don't replace AI analysis with systematic processes
   - Use systematic workflows to structure and quality-check AI output

2. **Configure Per Project**
   - Enable only needed systematic workflows
   - Customize templates for project-specific needs
   - Adjust configuration in `.ai-workflow.yaml`

3. **Integrate with Development Flow**
   - Run project analysis when starting on new codebases
   - Use quality checklists as development milestones
   - Generate documents from templates for consistency

## Troubleshooting

### Common Issues

**Scripts not executable:**
```bash
chmod +x core/workflows/systematic/*.sh
```

**VS Code tasks not appearing:**
- Ensure `.ai-workflow.yaml` has `systematic.enabled: true`
- Restart VS Code after configuration changes

**Template variables not substituting:**
- Check variable format: `{{VARIABLE_NAME}}`
- Ensure all variables are provided in interactive or batch mode

### Environment Detection

Systematic workflows automatically detect the environment:
- **VS Code:** Enhanced progress indicators and file opening
- **Terminal:** Basic progress output
- **Codespaces:** Cloud environment optimizations

## EmberCare Compatibility

✅ **All systematic workflows are designed to be fully compatible with existing EmberCare Flutter adapter patterns.**

- No changes to `adapters/flutter/` directory
- Existing AI workflows remain unchanged
- Configuration system maintains backward compatibility
- VS Code tasks are additive, not replacing existing tasks