<!-- Powered by BMAD™ Core -->

# Documentation Currency Checklist

This checklist provides comprehensive validation that project documentation remains current with development changes and system evolution. This validation ensures documentation serves as a reliable resource for users and development teams.

## Required Artifacts

Before starting this checklist, ensure access to:

- Current project documentation files (README, guides, API docs)
- Recent development changes and file modifications  
- AGENTS.md and agent definition files
- Task definitions and workflow documentation
- Configuration files and setup documentation

## LLM Instructions

When processing this checklist:

1. **Review each section systematically** - Don't skip items even if they seem redundant
2. **Think step-by-step** through each validation point
3. **Compare documentation against actual implementation** - Look for discrepancies
4. **Document specific examples** when gaps are found
5. **Assess user impact** of documentation issues
6. **Consider cross-references and dependencies** between documentation files

## Section 1: Core Documentation Accuracy

*LLM: Review fundamental project documentation for accuracy and currency. Check that basic project information matches current state.*

### 1.1 Project Overview Documentation

- [ ] **README.md accurately describes current project purpose and scope**
  - Project description matches actual functionality
  - Key features list is current and complete
  - Project status reflects actual development state

- [ ] **Installation instructions work with current project state**
  - Prerequisites are current and complete
  - Installation steps execute successfully
  - Dependencies and versions are accurate
  - Environment setup instructions are complete

- [ ] **Getting started guide reflects current user experience**
  - First-time user flow is accurate
  - Examples work with current implementation
  - Common setup issues are addressed
  - Initial configuration steps are complete

### 1.2 User-Facing Documentation

- [ ] **User guide content matches current functionality**
  - Feature descriptions are accurate
  - User workflows reflect current implementation
  - Screenshots and examples are current
  - User interface descriptions are accurate

- [ ] **API documentation is synchronized with implementation**
  - Endpoint documentation matches actual API
  - Parameter descriptions are accurate
  - Response examples reflect current behavior
  - Authentication requirements are current

### 1.3 Configuration Documentation

- [ ] **Configuration options are completely documented**
  - All configuration files are documented
  - Configuration parameters have accurate descriptions
  - Default values match actual defaults
  - Examples show current best practices

## Section 2: Process and Workflow Documentation

*LLM: Validate that documented processes and workflows match actual implementation and current practices.*

### 2.1 Development Workflow Documentation

- [ ] **Development process documentation is current**
  - Workflow steps match actual process
  - Tool requirements are accurate
  - Integration points are documented correctly
  - Quality gates and checkpoints are current

- [ ] **Build and deployment documentation works**
  - Build instructions execute successfully
  - Deployment procedures are accurate
  - Environment-specific information is current
  - Troubleshooting information is relevant

### 2.2 Contributing and Collaboration Documentation

- [ ] **Contribution guidelines reflect current practices**
  - Code review process is accurately documented
  - Coding standards match actual requirements
  - Pull request process is current
  - Issue reporting guidelines are relevant

- [ ] **Team collaboration processes are documented**
  - Communication channels are current
  - Meeting structures are accurate
  - Decision-making processes are documented
  - Escalation procedures are clear

## Section 3: BMAD-Specific Documentation

*LLM: Focus on BMAD framework documentation that supports agent coordination and task execution.*

### 3.1 Agent Documentation Currency

- [ ] **AGENTS.md reflects current agent definitions**
  - Agent list matches actual .bmad-core/agents/ files
  - Agent capabilities are accurately described
  - Agent interaction patterns are current
  - When-to-use guidance is accurate

- [ ] **Individual agent documentation is current**
  - Agent capabilities match implementation
  - Command lists are complete and accurate
  - Task dependencies are correctly documented
  - Agent workflows are current

### 3.2 Task and Workflow Documentation

- [ ] **Task definitions match implementation**
  - Task descriptions reflect actual functionality
  - Task inputs and outputs are accurate
  - Task dependencies are correctly documented
  - Task execution instructions work correctly

- [ ] **Workflow documentation is current**
  - Process flows match actual implementation
  - Integration points are accurately described
  - Agent coordination patterns are documented
  - Workflow triggers and conditions are current

### 3.3 Template and Configuration Documentation

- [ ] **Template documentation is accurate**
  - Template usage instructions are current
  - Template customization options are documented
  - Template dependencies are accurate
  - Example usage reflects current practices

- [ ] **Configuration documentation is complete**
  - Core-config.yaml options are documented
  - Configuration examples are current
  - Default values match implementation
  - Environment-specific configurations are accurate

## Section 4: Technical Documentation Validation

*LLM: Ensure technical documentation provides accurate guidance for development and integration.*

### 4.1 Architecture Documentation

- [ ] **System architecture documentation is current**
  - Component descriptions match implementation
  - Integration patterns are accurately documented
  - Data flow descriptions are current
  - Technology choices are documented correctly

- [ ] **Technical specifications are accurate**
  - Interface specifications match implementation
  - Protocol documentation is current
  - Data format specifications are accurate
  - Performance characteristics are documented correctly

### 4.2 Code Documentation and Examples

- [ ] **Code examples compile and execute correctly**
  - Example code uses current syntax
  - Dependencies in examples are current
  - Example outputs match current behavior
  - Integration examples work correctly

- [ ] **API documentation matches implementation**
  - Method signatures are accurate
  - Parameter types and constraints are current
  - Return value documentation is accurate
  - Error handling documentation is complete

## Section 5: User Experience Documentation

*LLM: Validate that documentation supports positive user experience and successful task completion.*

### 5.1 User Journey Documentation

- [ ] **Common user scenarios are documented accurately**
  - End-to-end workflows are current
  - User decision points are clearly documented
  - Success criteria are accurately described
  - Alternative paths are documented

- [ ] **Troubleshooting documentation is relevant**
  - Common issues reflect current problems
  - Solution steps work with current implementation
  - Error messages match current system behavior
  - Diagnostic procedures are accurate

### 5.2 Integration and Extension Documentation

- [ ] **Integration documentation is current**
  - Third-party integration instructions work
  - Customization options are accurately documented
  - Extension points are clearly described
  - Migration documentation is current

- [ ] **Advanced usage documentation is accurate**
  - Advanced configuration options are documented
  - Performance tuning guidance is current
  - Monitoring and observability documentation works
  - Security configuration guidance is accurate

## Section 6: Documentation Quality and Consistency

*LLM: Assess overall documentation quality and internal consistency across all documentation files.*

### 6.1 Cross-Reference Validation

- [ ] **Internal links and references work correctly**
  - All internal links resolve correctly
  - Cross-references are accurate and current
  - Navigation between documents is logical
  - Table of contents entries are accurate

- [ ] **External references are current**
  - External links are functional
  - Version references are current
  - Third-party documentation references are accurate
  - Resource links provide current information

### 6.2 Consistency and Standards

- [ ] **Documentation follows consistent formatting standards**
  - Style guide compliance across all documents
  - Consistent terminology usage
  - Uniform structure and organization
  - Consistent code formatting and examples

- [ ] **Information architecture is logical and complete**
  - Document organization supports user tasks
  - Information hierarchy is clear
  - Related information is appropriately grouped
  - Navigation supports efficient information finding

## Section 7: Documentation Completeness Assessment

*LLM: Identify gaps where new functionality or changes lack adequate documentation.*

### 7.1 New Feature Documentation

- [ ] **Recent feature additions are documented**
  - All new features have user documentation
  - New configuration options are documented
  - New integration points are described
  - Migration guidance is provided for breaking changes

- [ ] **Changed functionality is properly documented**
  - Modified behavior is accurately described
  - Deprecated features are clearly marked
  - Backward compatibility information is provided
  - Change impact is clearly communicated

### 7.2 Gap Identification and Prioritization

- [ ] **Documentation gaps are identified and assessed**
  - Missing documentation is catalogued
  - Gap severity is assessed (critical/major/minor)
  - User impact of gaps is evaluated
  - Gap resolution priority is established

- [ ] **Documentation debt is tracked and managed**
  - Accumulated documentation debt is quantified
  - Debt reduction plan exists
  - Regular debt review process is established
  - Debt accumulation is controlled

## Completion Criteria

This checklist is complete when:

- All documentation files have been reviewed for currency and accuracy
- Documentation gaps have been identified and prioritized
- Critical and major gaps have been resolved or scheduled
- User-facing changes have appropriate documentation
- Cross-references and navigation are verified as functional
- Documentation quality meets project standards

## Output Requirements

Generate comprehensive documentation currency report including:

- **Overall Status**: Documentation health summary
- **Gap Analysis**: Detailed list of identified issues by priority
- **Update Recommendations**: Specific actions needed to resolve gaps
- **Quality Assessment**: Overall documentation quality evaluation
- **Action Plan**: Timeline and responsibility for addressing identified issues

This checklist ensures systematic evaluation of documentation currency and provides actionable guidance for maintaining high-quality, current documentation that serves users and development teams effectively.