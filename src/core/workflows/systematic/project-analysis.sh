#!/bin/bash

# Project Analysis Workflow
# Extracted from EmberCare systematic workflows
# Adapted for RAPID-AI direct AI integration

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
OUTPUT_DIR="${PROJECT_ROOT}/docs"
ARCHITECTURE_FILE="${OUTPUT_DIR}/brownfield-architecture.md"

print_status() {
    local message="$1"
    echo "📋 ${message}"
}

analyze_project_structure() {
    print_status "Analyzing project structure..."
    
    local structure_analysis="${OUTPUT_DIR}/project-structure-analysis.md"
    
    cat > "${structure_analysis}" << 'EOF'
# Project Structure Analysis

## Directory Structure
EOF
    
    # Add actual directory tree
    if command -v tree >/dev/null 2>&1; then
        echo -e "\n\`\`\`" >> "${structure_analysis}"
        tree -I 'node_modules|.git|*.log' "${PROJECT_ROOT}" >> "${structure_analysis}"
        echo -e "\`\`\`\n" >> "${structure_analysis}"
    else
        echo -e "\n\`\`\`" >> "${structure_analysis}"
        find "${PROJECT_ROOT}" -type d -name ".git" -prune -o -type d -name "node_modules" -prune -o -type f -print | head -50 >> "${structure_analysis}"
        echo -e "\`\`\`\n" >> "${structure_analysis}"
    fi
    
    echo "## Key Files Identified" >> "${structure_analysis}"
    
    # Identify key configuration files
    for file in package.json requirements.txt Cargo.toml pom.xml pubspec.yaml; do
        if [ -f "${PROJECT_ROOT}/${file}" ]; then
            echo "- Configuration: \`${file}\`" >> "${structure_analysis}"
        fi
    done
    
    # Identify main entry points
    for file in src/main.js src/index.js app.js server.js main.py __init__.py lib/main.dart; do
        if [ -f "${PROJECT_ROOT}/${file}" ]; then
            echo "- Entry Point: \`${file}\`" >> "${structure_analysis}"
        fi
    done
    
    print_status "Project structure analysis saved to ${structure_analysis}"
}

identify_tech_stack() {
    print_status "Identifying technology stack..."
    
    local tech_analysis="${OUTPUT_DIR}/tech-stack-analysis.md"
    
    cat > "${tech_analysis}" << 'EOF'
# Technology Stack Analysis

## Detected Technologies
EOF
    
    # Analyze package.json if present
    if [ -f "${PROJECT_ROOT}/package.json" ]; then
        echo -e "\n### Node.js/JavaScript" >> "${tech_analysis}"
        echo "- Package Manager: npm/yarn" >> "${tech_analysis}"
        
        # Extract key dependencies
        if command -v jq >/dev/null 2>&1; then
            local deps=$(jq -r '.dependencies | keys[]' "${PROJECT_ROOT}/package.json" 2>/dev/null | head -10)
            if [ -n "$deps" ]; then
                echo "- Key Dependencies:" >> "${tech_analysis}"
                echo "$deps" | sed 's/^/  - /' >> "${tech_analysis}"
            fi
        fi
    fi
    
    # Analyze other tech stacks
    if [ -f "${PROJECT_ROOT}/requirements.txt" ]; then
        echo -e "\n### Python" >> "${tech_analysis}"
        echo "- Package Manager: pip" >> "${tech_analysis}"
    fi
    
    if [ -f "${PROJECT_ROOT}/pubspec.yaml" ]; then
        echo -e "\n### Flutter/Dart" >> "${tech_analysis}"
        echo "- Package Manager: pub" >> "${tech_analysis}"
    fi
    
    print_status "Technology stack analysis saved to ${tech_analysis}"
}

generate_brownfield_documentation() {
    print_status "Generating brownfield architecture documentation..."
    
    cat > "${ARCHITECTURE_FILE}" << 'EOF'
# Brownfield Architecture Document

## Introduction

This document captures the CURRENT STATE of the project, including technical debt, workarounds, and real-world patterns. It serves as a reference for AI agents working on enhancements.

### Document Scope

Comprehensive documentation of existing system for AI-powered development assistance.

### Change Log

| Date | Version | Description | Author |
|------|---------|-------------|--------|
| $(date +%Y-%m-%d) | 1.0 | Initial brownfield analysis | RAPID-AI Analysis |

## Quick Reference - Key Files and Entry Points

### Critical Files for Understanding the System

EOF
    
    # Add detected entry points and config files
    for file in src/main.js src/index.js app.js package.json; do
        if [ -f "${PROJECT_ROOT}/${file}" ]; then
            echo "- **${file}**: $(basename ${file} | tr '[:lower:]' '[:upper:]') entry point/configuration" >> "${ARCHITECTURE_FILE}"
        fi
    done
    
    cat >> "${ARCHITECTURE_FILE}" << 'EOF'

## High Level Architecture

### Technical Summary

[To be populated with specific technology stack analysis]

### Repository Structure Reality Check

- Type: [Detected during analysis]
- Package Manager: [Detected during analysis]
- Notable: [Unusual structure decisions discovered]

## Source Tree and Module Organization

[Include structure from project-structure-analysis.md]

## Technical Debt and Known Issues

### Areas Requiring Analysis

1. **Legacy Components**: [To be identified during deeper analysis]
2. **Inconsistent Patterns**: [To be documented as discovered]
3. **Technical Constraints**: [To be identified]

### Workarounds and Gotchas

[To be populated during development]

## Integration Points and External Dependencies

### External Services

[To be identified from configuration analysis]

### Internal Integration Points

[To be mapped during code analysis]

## Development and Deployment

### Local Development Setup

[To be documented based on discovered build scripts]

### Build and Deployment Process

[To be extracted from package.json scripts and CI/CD configs]

## Testing Reality

### Current Test Coverage

[To be analyzed from test directories and configuration]

## Appendix - Useful Commands and Scripts

### Frequently Used Commands

[To be extracted from package.json scripts]

EOF
    
    print_status "Brownfield architecture documentation created at ${ARCHITECTURE_FILE}"
}

main() {
    print_status "Starting project analysis workflow..."
    
    # Ensure output directory exists
    mkdir -p "${OUTPUT_DIR}"
    
    # Run analysis steps
    analyze_project_structure
    identify_tech_stack
    generate_brownfield_documentation
    
    print_status "Project analysis complete!"
    print_status "Generated files:"
    print_status "  - ${OUTPUT_DIR}/project-structure-analysis.md"
    print_status "  - ${OUTPUT_DIR}/tech-stack-analysis.md" 
    print_status "  - ${ARCHITECTURE_FILE}"
    print_status ""
    print_status "Next steps:"
    print_status "  1. Review generated documentation"
    print_status "  2. Enhance with project-specific details"
    print_status "  3. Use as foundation for AI-powered development"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
