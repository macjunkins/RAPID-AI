# RAPID-AI Documentation Currency Checklist

This checklist provides comprehensive validation that project documentation remains current with development changes. This systematic approach ensures documentation serves as a reliable resource for users and development teams.

**Adapted from:** BMAD documentation workflow patterns
**Scope:** Applicable to all RAPID-AI project types (Flutter, React, Python, Go, Generic)

---

## Required Artifacts

Before starting this checklist, ensure access to:

- Current project documentation files (README, user guides, API docs)
- Recent development changes and file modifications
- Architecture and technical documentation
- Configuration files and setup documentation
- Project-specific documentation (adapter-dependent)

---

## LLM Instructions

When processing this checklist:

1. **Review each section systematically** - Don't skip items even if they seem redundant
2. **Think step-by-step** through each validation point
3. **Compare documentation against actual implementation** - Look for discrepancies
4. **Document specific examples** when gaps are found
5. **Assess user impact** of documentation issues
6. **Consider cross-references and dependencies** between documentation files
7. **Apply project-type specific validation** for adapter-specific documentation

---

## Section 1: Core Project Documentation

*LLM: Review fundamental project documentation for accuracy and currency. Check that basic project information matches current state.*

### 1.1 Project Overview Documentation

- [ ] **README.md accurately describes current project purpose and scope**
  - Project description matches actual functionality
  - Key features list is current and complete
  - Project status reflects actual development state
  - Installation instructions work with current project state

- [ ] **Getting started guide reflects current user experience**
  - First-time user flow is accurate
  - Examples work with current implementation
  - Common setup issues are addressed
  - Initial configuration steps are complete

- [ ] **Prerequisites and dependencies are current**
  - Required tools and versions are accurate
  - Environment requirements are complete
  - Installation steps execute successfully
  - Dependency lists match actual requirements

### 1.2 Configuration Documentation

- [ ] **Configuration options are completely documented**
  - All configuration files are documented (`.ai-workflow.yaml`, adapter configs)
  - Configuration parameters have accurate descriptions
  - Default values match actual defaults
  - Examples show current best practices

- [ ] **Environment-specific configuration is accurate**
  - Development environment setup is current
  - VS Code integration configuration is documented
  - CI/CD configuration is accurate (if applicable)
  - Project-type specific configuration is complete

---

## Section 2: RAPID-AI Framework Documentation

*LLM: Validate that RAPID-AI framework documentation matches implementation and usage patterns.*

### 2.1 Three-Layer Architecture Documentation

- [ ] **Core framework documentation is current**
  - Core scripts documentation matches implementation
  - AI integration patterns are accurately documented
  - Common functions and utilities are documented
  - Shell script standards are clearly defined

- [ ] **Adapter documentation is accurate**
  - Adapter-specific patterns are documented
  - Project-type requirements are clearly described
  - Adapter integration points are accurate
  - Examples show current adapter usage

- [ ] **VS Code Tasks documentation is complete**
  - Task definitions match `templates/vscode/tasks.json`
  - Task usage examples are current
  - Problem matchers and outputs are documented
  - Task parameters and inputs are accurate

### 2.2 AI Integration Documentation

- [ ] **AI tool integration is accurately documented**
  - GitHub Copilot CLI integration is current
  - AI abstraction layer is clearly explained
  - Timeout and error handling is documented
  - Environment detection patterns are accurate

- [ ] **AI workflow usage is documented**
  - Story analysis workflow is accurate
  - Implementation planning workflow is current
  - AI prompt customization is explained
  - Adapter-specific AI prompts are documented

---

## Section 3: Project-Type Specific Documentation

*LLM: Validate adapter-specific documentation matches project requirements. Skip sections not applicable to current project type.*

### 3.1 Flutter Adapter Documentation (if applicable)

- [ ] **Flutter-specific patterns are documented**
  - BLoC + Drift architecture patterns are accurate
  - Flutter discovery workflow is current
  - EmberCare integration patterns are documented
  - Flutter-specific testing approaches are described

### 3.2 React Adapter Documentation (if applicable)

- [ ] **React-specific patterns are documented**
  - State management patterns are accurate
  - Component architecture is described
  - React discovery workflow is current
  - Testing approaches are documented

### 3.3 Generic Project Documentation (if applicable)

- [ ] **Generic adapter patterns are documented**
  - Fallback analysis patterns are accurate
  - Template-based discovery is explained
  - Generic testing approaches are described

---

## Section 4: Workflow and Process Documentation

*LLM: Ensure workflow documentation matches actual development processes.*

### 4.1 Development Workflow Documentation

- [ ] **AI-powered workflows are accurately documented**
  - Story analysis process matches implementation
  - Implementation planning workflow is current
  - Complete story setup workflow is accurate
  - Systematic workflows are clearly described

- [ ] **VS Code task workflows are current**
  - Task execution flow is accurately documented
  - Progress indicators and feedback are explained
  - Error handling and problem detection is described
  - Task dependencies are correctly documented

### 4.2 Documentation Workflow Integration

- [ ] **Documentation-as-you-go workflow is documented**
  - Documentation detection logic is explained
  - Task completion verification is described
  - Documentation requirements are clearly defined
  - AI-powered documentation analysis is documented

- [ ] **Documentation verification process is current**
  - Checklist usage is explained
  - Gap identification process is described
  - Update workflow is clearly documented
  - Completion gate mechanism is explained

---

## Section 5: Technical and Architecture Documentation

*LLM: Validate technical documentation accuracy against implementation.*

### 5.1 Architecture Documentation

- [ ] **System architecture is accurately described**
  - Three-layer design is clearly explained
  - Core → Adapters → Templates structure is documented
  - Integration points are accurately described
  - Component interactions are current

- [ ] **Module organization is current**
  - Source tree structure matches actual layout
  - Module responsibilities are clearly defined
  - Dependencies between modules are accurate
  - File organization patterns are documented

### 5.2 Technical Standards and Patterns

- [ ] **Coding standards are current**
  - Shell script standards are clearly defined
  - POSIX compatibility requirements are documented
  - Environment detection patterns are explained
  - Error handling standards are described

- [ ] **Integration patterns are accurately documented**
  - Git workflow integration is current
  - VS Code integration patterns are accurate
  - AI tool abstraction is clearly explained
  - Adapter integration patterns are documented

---

## Section 6: User-Facing Documentation

*LLM: Ensure user documentation supports successful task completion and positive experience.*

### 6.1 Usage Examples and Guides

- [ ] **Command-line examples work correctly**
  - CLI usage examples use current syntax
  - Parameters and flags are accurate
  - Output examples match current behavior
  - Error message examples are current

- [ ] **VS Code task examples are current**
  - Task selection and execution is accurate
  - Input parameter examples are correct
  - Expected outputs are documented
  - Common scenarios are covered

### 6.2 Troubleshooting and Support

- [ ] **Troubleshooting information is relevant**
  - Common issues reflect current problems
  - Solution steps work with current implementation
  - Error messages match current system behavior
  - Diagnostic procedures are accurate

- [ ] **Support resources are current**
  - Links to documentation are functional
  - External references are valid
  - Version-specific information is accurate
  - Community resources are up-to-date

---

## Section 7: Documentation Quality and Consistency

*LLM: Assess overall documentation quality across all documentation files.*

### 7.1 Cross-Reference Validation

- [ ] **Internal links and references work correctly**
  - All internal links resolve correctly
  - Cross-references are accurate and current
  - Navigation between documents is logical
  - File paths and references are valid

- [ ] **External references are current**
  - External links are functional
  - Version references are current
  - Third-party documentation references are accurate
  - Resource links provide current information

### 7.2 Consistency and Standards

- [ ] **Documentation follows consistent formatting**
  - Style guide compliance across all documents
  - Consistent terminology usage
  - Uniform structure and organization
  - Consistent code formatting and examples

- [ ] **Information architecture is logical**
  - Document organization supports user tasks
  - Information hierarchy is clear
  - Related information is appropriately grouped
  - Navigation supports efficient information finding

---

## Section 8: Completeness and Gap Assessment

*LLM: Identify gaps where new functionality or changes lack adequate documentation.*

### 8.1 Recent Changes Documentation

- [ ] **Recent feature additions are documented**
  - All new features have user documentation
  - New configuration options are documented
  - New workflow capabilities are described
  - Migration guidance provided for changes

- [ ] **Modified functionality is documented**
  - Changed behavior is accurately described
  - Deprecated features are clearly marked
  - Backward compatibility information is provided
  - Change impact is clearly communicated

### 8.2 Gap Identification and Prioritization

- [ ] **Documentation gaps are identified**
  - Missing documentation is catalogued
  - Gap severity is assessed (critical/major/minor)
  - User impact of gaps is evaluated
  - Resolution priority is established

- [ ] **Documentation debt is managed**
  - Accumulated debt is quantified
  - Debt reduction plan exists
  - Regular review process is established
  - Debt accumulation is controlled

---

## Completion Criteria

This checklist is complete when:

- All applicable documentation files have been reviewed for currency and accuracy
- Documentation gaps have been identified and prioritized
- Critical and major gaps have been resolved or scheduled
- User-facing changes have appropriate documentation
- Cross-references and navigation are verified as functional
- Documentation quality meets project standards
- Project-type specific documentation is validated

---

## Output Requirements

Generate comprehensive documentation currency report including:

- **Overall Status**: Documentation health summary with specific RAPID-AI context
- **Gap Analysis**: Detailed list of identified issues by priority (critical/major/minor)
- **Adapter-Specific Issues**: Project-type specific documentation gaps
- **Update Recommendations**: Specific actions needed to resolve gaps
- **Action Plan**: Timeline and responsibility for addressing identified issues

---

## RAPID-AI Specific Considerations

### For Core Framework Changes:
- Validate `core/scripts/` documentation matches implementation
- Check `core/workflows/common-functions.sh` is accurately documented
- Ensure AI integration patterns are current

### For Adapter Changes:
- Validate adapter-specific documentation (Flutter, React, etc.)
- Check adapter configuration documentation
- Ensure adapter integration examples are current

### For VS Code Task Changes:
- Validate `templates/vscode/tasks.json` documentation
- Check task usage examples are accurate
- Ensure problem matcher patterns are documented

---

**This checklist ensures systematic evaluation of RAPID-AI documentation currency and provides actionable guidance for maintaining high-quality, current documentation across all project types.**
