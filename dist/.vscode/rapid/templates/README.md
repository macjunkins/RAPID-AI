# RAPID-AI Template Files

This directory contains 13 YAML template files maintained for RAPID-AI after extracting them from EmberCare's legacy methodology.

## Template Inventory

| Template File | ID | Version | Purpose |
|--------------|-----|---------|---------|
| architecture-tmpl.yaml | architecture-template | 3.0 | Backend/system architecture documentation |
| brainstorming-output-tmpl.yaml | brainstorming-output-template | 3.0 | Brainstorming session results capture |
| brownfield-architecture-tmpl.yaml | brownfield-architecture-template | 3.0 | Architecture for enhancing existing projects |
| brownfield-prd-tmpl.yaml | brownfield-prd-template | 3.0 | PRD for significant brownfield enhancements |
| competitor-analysis-tmpl.yaml | competitor-analysis-template | 3.0 | Competitive landscape analysis |
| front-end-architecture-tmpl.yaml | frontend-architecture-template | 3.0 | Frontend-specific architecture details |
| front-end-spec-tmpl.yaml | frontend-spec-template | 3.0 | UI/UX specification and design system |
| fullstack-architecture-tmpl.yaml | fullstack-architecture-template | 3.0 | Unified fullstack architecture |
| market-research-tmpl.yaml | market-research-template | 3.0 | Market research and analysis |
| prd-tmpl.yaml | prd-template | 3.0 | Product requirements document |
| project-brief-tmpl.yaml | project-brief-template | 3.0 | Initial project planning and scoping |
| qa-gate-tmpl.yaml | qa-gate-template | 1.0 | Quality gate decision tracking |
| story-tmpl.yaml | story-template | 3.0 | User story documentation |

## Template Structure

All templates follow this structure:

```yaml
template:
  id: <template-name>-template
  name: <Human Readable Name>
  version: 3.0
  framework: RAPID-AI
  output:
    format: markdown|yaml
    filename: <output-path>
    title: <document-title>

workflow:
  mode: interactive|non-interactive
  elicitation: advanced-elicitation

sections:
  # Template-specific sections...
```

## Key Features

- **Framework Field**: All templates identify themselves as `framework: RAPID-AI`
- **Version Tracking**: Templates use semantic versioning (currently v3.0, except qa-gate at v1.0)
- **Path References**: All file paths use `src/rapid/` prefix
- **Slash Commands**: All commands use `/rapid` prefix
- **No Legacy Branding**: Historical marks from the deprecated methodology have been removed

## Usage

These templates are designed to be used by:
1. RAPID-AI CLI tools for document generation
2. AI agents for structured story and architecture processing
3. Documentation generation workflows
4. Interactive document creation sessions

## Transformation Details

See `TRANSFORMATION_REPORT.md` for detailed notes on the legacy-to-RAPID migration.

---

**Last Updated:** 2025-10-24  
**Total Templates:** 13  
**Framework:** RAPID-AI v3.0
