<!-- Powered by BMAD™ Core -->

# Validate Documentation Currency Task

## Purpose

To systematically check if project documentation is current with recent code changes and development activities. This task identifies documentation gaps and ensures user-facing documentation stays aligned with actual system behavior.

## Prerequisites

- Access to project documentation files
- Understanding of recent development changes
- File change tracking capability

## Process

### 1. Identify Documentation Scope

Determine which documentation files need validation based on:

- **Core Documentation**: README, user guides, API documentation
- **Process Documentation**: Development workflows, deployment guides
- **Agent Documentation**: AGENTS.md and agent-specific documentation
- **Technical Documentation**: Architecture docs, technical specifications

### 2. Analyze Recent Changes

Review recent development activities to identify potential documentation impacts:

- **File Changes**: New files, modified files, deleted files
- **Feature Changes**: New features, modified functionality, removed features
- **Configuration Changes**: New settings, modified workflows, updated dependencies
- **Agent Changes**: Modified agent definitions, new tasks, updated workflows

### 3. Documentation Currency Check

For each documentation file in scope:

#### Content Alignment Verification
- Compare documented features against actual implementation
- Verify code examples and snippets are current
- Check that screenshots and UI descriptions match current interface
- Validate that workflow descriptions match actual process

#### Completeness Assessment
- Identify new features missing from documentation
- Check if deprecated features are removed from docs
- Verify all configuration options are documented
- Ensure all agent capabilities are properly described

#### Accuracy Validation
- Test documented procedures to ensure they work
- Verify links and references are not broken
- Check that version information is current
- Validate that troubleshooting information is relevant

### 4. Gap Documentation

Document identified gaps in structured format:

```yaml
documentation_gaps:
  file: path/to/documentation/file.md
  type: content|completeness|accuracy
  severity: critical|major|minor
  description: "Brief description of the gap"
  impact: "How this affects user experience"
  suggested_action: "Recommended fix"
  related_changes: ["list", "of", "related", "files"]
```

### 5. Priority Assessment

Classify documentation gaps by priority:

- **Critical**: Incorrect information that could break user workflows
- **Major**: Missing information for new features or significant changes
- **Minor**: Outdated examples or minor inconsistencies

### 6. Generate Documentation Update Plan

Create actionable plan for documentation updates:

1. **Immediate Actions**: Critical fixes that should be addressed immediately
2. **Short-term Actions**: Major updates for next documentation cycle
3. **Maintenance Actions**: Minor improvements and cleanup items

## Output Requirements

### Validation Report

Generate comprehensive report including:

- **Executive Summary**: Overall documentation health status
- **Gap Analysis**: Detailed list of identified issues by priority
- **Update Plan**: Recommended actions with timeline
- **Impact Assessment**: How gaps affect user experience

### Action Items

Provide specific, actionable items for documentation team:

- File-specific update requirements
- Content creation needs
- Review and validation tasks
- Timeline recommendations

## Integration with Development Workflow

### Pre-Completion Check

This task should be executed before marking development tasks complete to ensure:

- New features are documented
- Changed workflows are updated in documentation
- Deprecated features are removed from docs
- User-facing changes have appropriate documentation updates

### Continuous Validation

Establish regular documentation validation schedule:

- After major feature releases
- During sprint retrospectives
- Before public releases
- When significant process changes occur

## Quality Criteria

Documentation is considered current when:

- All user-facing features are accurately documented
- Workflow descriptions match actual processes
- Code examples compile and execute correctly
- Links and references are functional
- Version information is up-to-date
- Troubleshooting information addresses current issues

## Tools and Automation

Leverage available tools for validation:

- Automated link checking
- Code example validation
- Screenshot comparison tools
- Version tracking systems
- Change detection automation

## Blocking Conditions

Documentation validation should block task completion when:

- Critical documentation gaps are identified
- User-facing changes lack documentation
- Existing documentation contains incorrect information
- Required documentation updates are not completed

This validation ensures that documentation remains a reliable resource for users and maintains the quality standards expected from systematic development processes.