# Systematic Workflows Configuration Guide

## Quick Start

1. **Enable systematic workflows** in `.ai-workflow.yaml`:
   ```yaml
   systematic:
     enabled: true
   ```

2. **Restart VS Code** to load new tasks

3. **Run systematic workflows** via VS Code tasks:
   - `Cmd+Shift+P` → "Tasks: Run Task" → Select systematic workflow

## Configuration Options

### Basic Configuration

```yaml
systematic:
  enabled: true  # Enable/disable all systematic workflows
  workflows:
    project_analysis:
      enabled: true
      auto_run: false
    quality_checklist:
      enabled: true
      auto_generate: true
      interactive_mode: true
    document_generation:
      enabled: true
      templates_dir: "core/workflows/systematic/templates"
      output_dir: "docs"
```

### Advanced Configuration

```yaml
systematic:
  enabled: true
  
  # Global settings
  output_dir: "docs"
  templates_dir: "core/workflows/systematic/templates"
  
  # Workflow-specific settings
  workflows:
    project_analysis:
      enabled: true
      auto_run: false
      outputs:
        - "docs/project-structure-analysis.md"
        - "docs/tech-stack-analysis.md"
        - "docs/brownfield-architecture.md"
      include_dependencies: true
      analyze_tests: true
    
    quality_checklist:
      enabled: true
      auto_generate: true
      interactive_mode: true
      checklist_file: "docs/quality-checklist.md"
      sections:
        - "requirements"
        - "code_quality"
        - "testing"
        - "documentation"
    
    document_generation:
      enabled: true
      templates_dir: "core/workflows/systematic/templates"
      output_dir: "docs"
      auto_open_generated: true
      variable_prompts: true
```

## Project-Specific Examples

### Flutter Project

```yaml
project:
  type: "flutter"
  architecture: ["bloc", "drift"]

systematic:
  enabled: true
  workflows:
    project_analysis:
      enabled: true
      flutter_specific: true
      analyze_pubspec: true
    quality_checklist:
      enabled: true
      flutter_checklist: true
```

### React Project

```yaml
project:
  type: "react"
  architecture: ["hooks", "redux"]

systematic:
  enabled: true
  workflows:
    project_analysis:
      enabled: true
      analyze_package_json: true
      include_webpack_config: true
```

### Generic/Node.js Project

```yaml
project:
  type: "generic"

systematic:
  enabled: true
  workflows:
    project_analysis:
      enabled: true
      generic_analysis: true
```

## Workflow-Specific Settings

### Project Analysis

```yaml
systematic:
  workflows:
    project_analysis:
      enabled: true
      auto_run: false              # Don't run automatically
      include_dependencies: true   # Analyze dependencies
      analyze_tests: true         # Include test analysis
      max_files: 100              # Limit file analysis
      exclude_dirs:               # Directories to exclude
        - "node_modules"
        - ".git"
        - "build"
      outputs:                    # Customize output files
        - "docs/project-analysis.md"
        - "docs/tech-stack.md"
```

### Quality Checklist

```yaml
systematic:
  workflows:
    quality_checklist:
      enabled: true
      auto_generate: true         # Generate for each story
      interactive_mode: true      # Use interactive review
      checklist_file: "docs/quality-checklist.md"
      open_in_editor: true       # Auto-open in VS Code
      sections:                  # Customize checklist sections
        - "requirements"
        - "code_quality"
        - "testing"
        - "build"
        - "documentation"
```

### Document Generation

```yaml
systematic:
  workflows:
    document_generation:
      enabled: true
      templates_dir: "core/workflows/systematic/templates"
      output_dir: "docs"
      auto_open_generated: true  # Open generated docs
      variable_prompts: true     # Prompt for variables
      custom_templates:          # Additional template locations
        - "project-templates/"
      variable_defaults:         # Default variable values
        AUTHOR: "Development Team"
        PROJECT_NAME: "My Project"
```

## Integration Settings

### VS Code Integration

```yaml
integrations:
  vscode:
    enabled: true
    systematic_tasks: true       # Enable systematic VS Code tasks
    auto_open_files: true       # Auto-open generated files
    task_group: "build"         # VS Code task group
```

### Git Integration

```yaml
integrations:
  git:
    systematic_commits: true    # Auto-commit systematic outputs
    branch_pattern: "docs/{type}-{date}"  # Branch for doc updates
    commit_message: "docs: systematic workflow updates"
```

## Environment-Specific Configuration

### Development Environment

```yaml
systematic:
  enabled: true
  debug_mode: true             # Verbose output
  keep_temp_files: true        # Keep temporary files
```

### CI/CD Environment

```yaml
systematic:
  enabled: false               # Disable in CI/CD
  # OR enable specific workflows only
  workflows:
    project_analysis:
      enabled: true
      auto_run: true
    quality_checklist:
      enabled: false           # Skip interactive workflows
```

## Troubleshooting Configuration

### Verify Configuration

```bash
# Check if configuration is valid
grep -A 20 "systematic:" .ai-workflow.yaml

# Test workflow availability
ls -la core/workflows/systematic/
```

### Common Issues

**Systematic workflows not appearing in VS Code:**
1. Check `systematic.enabled: true` in `.ai-workflow.yaml`
2. Restart VS Code
3. Verify tasks file includes systematic tasks

**Scripts not executable:**
```bash
chmod +x core/workflows/systematic/*.sh
```

**Configuration not taking effect:**
1. Verify YAML syntax
2. Check indentation (use spaces, not tabs)
3. Restart development environment

### Debug Mode

Enable debug output for troubleshooting:

```yaml
systematic:
  enabled: true
  debug_mode: true
```

This will provide verbose output from systematic workflow scripts.

## Migration from BMAD

If migrating from BMAD-METHOD projects:

1. **Disable BMAD agents** in existing configuration
2. **Enable systematic workflows** with equivalent functionality
3. **Update VS Code tasks** to use RAPID-AI systematic workflows
4. **Migrate custom templates** to `core/workflows/systematic/templates/`

Example migration:

```yaml
# OLD: BMAD configuration
bmad:
  agents:
    enabled: false

# NEW: RAPID-AI systematic workflows
systematic:
  enabled: true
  workflows:
    project_analysis:
      enabled: true    # Replaces BMAD document-project
    quality_checklist:
      enabled: true    # Replaces BMAD quality gates
    document_generation:
      enabled: true    # Replaces BMAD template system
```