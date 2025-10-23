<!-- Powered by BMAD™ Core -->

# Documentation Completion Gate Task

## Purpose

To enforce documentation verification as a mandatory step before marking development tasks complete. This gate ensures that user-facing documentation stays current with development changes and prevents completion of tasks that have outstanding documentation requirements.

## Prerequisites

- Completed development work ready for final validation
- Understanding of changes made during development
- Access to project documentation files

## Gate Criteria

Development tasks cannot be marked complete until all documentation requirements are satisfied:

### Mandatory Documentation Checks

1. **User-Facing Changes Documented**: All changes that affect user experience are properly documented
2. **API Changes Documented**: New or modified APIs have updated documentation
3. **Configuration Changes Documented**: New settings or configuration options are documented
4. **Workflow Changes Documented**: Modified processes or procedures are updated in documentation
5. **Troubleshooting Updated**: New error conditions or solutions are added to troubleshooting guides

### Documentation Quality Standards

Documentation must meet quality standards:

- **Accuracy**: Information matches actual implementation
- **Completeness**: All necessary information is provided
- **Clarity**: Information is presented clearly for target audience
- **Consistency**: Follows project documentation standards
- **Testability**: Procedures and examples have been validated

## Gate Process

### 1. Documentation Impact Assessment

Evaluate development changes for documentation requirements:

#### Change Analysis
- Review all files modified during development
- Identify user-facing changes that need documentation
- Assess impact on existing documentation accuracy
- Determine scope of required documentation updates

#### Documentation Scope Determination
- Identify specific documentation files that need updates
- Determine new documentation that needs to be created
- Assess cross-references and related documentation impact
- Plan validation and testing requirements for documentation

### 2. Documentation Currency Validation

Execute systematic validation of documentation currency:

#### Execute Validation Task
- Run `validate-documentation-currency.md` task
- Review identified documentation gaps
- Assess severity and impact of gaps
- Determine if gaps block task completion

#### AI-Enhanced Validation
- Use AI analysis to compare documentation against current implementation
- Generate AI suggestions for documentation improvements
- Automated detection of documentation inconsistencies
- AI-powered gap analysis for comprehensive coverage

#### Gap Resolution Assessment
- Critical gaps must be resolved before completion
- Major gaps should be addressed or scheduled
- Minor gaps can be addressed in future cycles
- Document rationale for any deferred gap resolution

### 3. Required Documentation Updates

Complete necessary documentation updates:

#### Execute Update Task
- Run `update-documentation.md` task for identified gaps
- Ensure all critical and major documentation issues are resolved
- Validate that updates are accurate and complete
- Test updated documentation procedures and examples

#### Quality Verification
- Verify updated documentation meets quality standards
- Test all examples and procedures work correctly
- Validate links and cross-references are accurate
- Ensure consistency across all updated documentation

### 4. Documentation Testing and Validation

Perform comprehensive testing of documentation:

#### Functional Testing
- Execute all documented procedures to verify accuracy
- Test code examples and configuration instructions
- Validate troubleshooting information works correctly
- Confirm integration instructions are complete

#### User Experience Testing
- Review documentation from user perspective
- Ensure information flow is logical and complete
- Verify common use cases are adequately covered
- Test that users can successfully follow documentation

### 5. Gate Decision

Make final determination on task completion readiness:

#### Completion Criteria Met
If all documentation requirements are satisfied:
- Document completion of documentation verification
- Update task status to indicate documentation compliance
- Allow task to proceed to completion
- Record documentation updates in task records

#### Completion Criteria Not Met
If documentation requirements are not satisfied:
- Block task completion until requirements are met
- Document specific documentation gaps that must be resolved
- Provide clear guidance on what needs to be completed
- Schedule documentation work before task can be completed

## Blocking Conditions

Task completion is blocked when:

- **Critical Documentation Gaps**: User-facing changes lack proper documentation
- **Broken Documentation**: Existing documentation is incorrect due to changes
- **Missing User Guidance**: New features lack adequate user documentation
- **Incomplete API Documentation**: API changes are not properly documented
- **Process Documentation Gaps**: Workflow changes are not reflected in documentation

## Integration with Development Workflow

### Pre-Completion Integration

This gate integrates with development workflow:

- **Automatic Execution**: Triggered as part of task completion process
- **Workflow Integration**: Built into development agent completion workflow
- **Progress Tracking**: Documentation status tracked in task progress
- **Clear Feedback**: Specific guidance provided when documentation is incomplete

### Agent Workflow Integration

Integration with BMAD agent system:

- **Dev Agent Integration**: Documentation verification required before marking tasks complete
- **Task Dependencies**: Documentation tasks become prerequisites for completion
- **Agent Coordination**: Clear handoff between development and documentation verification
- **Status Tracking**: Documentation status visible in agent workflow progress

## Output Requirements

### Gate Status Report

Provide clear status on documentation compliance:

- **Gate Status**: PASS/FAIL with clear rationale
- **Documentation Gaps**: Specific gaps that need resolution
- **Update Summary**: Documentation updates completed
- **Next Steps**: Clear guidance for addressing any remaining issues

### Task Integration

Update task tracking with documentation status:

- **Completion Status**: Documentation verification results
- **Gap Resolution**: Record of documentation gaps addressed
- **Update Summary**: Summary of documentation changes made
- **Compliance Confirmation**: Verification that documentation requirements are met

## Quality Assurance

Ensure gate effectiveness:

### Gate Reliability
- Consistently applied across all development tasks
- Clear criteria that can be objectively evaluated
- Reliable detection of documentation gaps
- Appropriate blocking of incomplete tasks

### Process Improvement
- Regular review of gate effectiveness
- Feedback collection on gate process
- Continuous improvement of documentation standards
- Integration optimization with development workflow

## Exception Handling

Handle special cases appropriately:

### Emergency Releases
- Document process for emergency releases with documentation debt
- Ensure documentation debt is tracked and scheduled
- Require explicit approval for documentation exceptions
- Plan for expedited documentation completion post-release

### Technical Debt
- Track accumulated documentation debt
- Schedule regular debt reduction activities
- Prevent excessive accumulation of documentation debt
- Balance development velocity with documentation quality

This gate ensures that documentation remains current and valuable while maintaining development velocity and supporting systematic, deliberate progress in project development.