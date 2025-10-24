# Task Completion Checklist with Documentation Verification

## Purpose
This checklist ensures that all development tasks include proper documentation verification before being marked as complete. It implements the documentation-as-you-go workflow to keep user documentation current with development activities.

## Pre-Completion Verification

### 1. Code Quality
- [ ] Code follows project coding standards
- [ ] All tests pass (unit, integration, e2e as applicable)
- [ ] Code has been reviewed (self-review or peer review)
- [ ] No TODO or FIXME comments remain without tracking tickets

### 2. Documentation Currency Verification (REQUIRED)
- [ ] Run documentation verification: `./core/scripts/task-completion-check.sh`
- [ ] All documentation requirements identified and addressed
- [ ] User-facing changes are reflected in relevant documentation
- [ ] API changes are documented in API documentation
- [ ] Configuration changes are documented in setup guides

### 3. Specific Documentation Types

#### For Feature Development:
- [ ] User documentation updated if user-facing features changed
- [ ] README updated if installation/setup process changed
- [ ] Architecture documentation updated if significant structural changes made
- [ ] API documentation updated if endpoints/interfaces changed

#### For Bug Fixes:
- [ ] Known issues documentation updated if bug was documented
- [ ] Troubleshooting guides updated if new solutions discovered
- [ ] Change log or release notes updated for significant fixes

#### For Configuration Changes:
- [ ] Configuration documentation updated
- [ ] Environment setup guides updated
- [ ] Deployment documentation updated if deployment process affected

### 4. Integration Requirements
- [ ] Changes integrate properly with existing codebase
- [ ] No breaking changes introduced without proper versioning
- [ ] Dependencies updated and documented if necessary
- [ ] Backward compatibility maintained or breaking changes documented

### 5. Quality Assurance
- [ ] Functionality tested manually in development environment
- [ ] Edge cases considered and tested
- [ ] Error handling verified and appropriate
- [ ] Performance impact assessed for significant changes

## Documentation Verification Process

### Automated Verification
1. **Run Task Completion Check**: 
   ```bash
   ./core/scripts/task-completion-check.sh
   ```

2. **Review Output**: Check for any documentation requirements identified

3. **Address Requirements**: Update any documentation files identified as needing updates

4. **Re-verify**: Run the check again until no documentation issues remain

### Manual Documentation Review
- [ ] Documentation changes are accurate and complete
- [ ] Documentation follows project documentation standards
- [ ] Links and references in documentation are valid
- [ ] Documentation is written for the appropriate audience
- [ ] Screenshots or examples are current and accurate

## Completion Approval

### Self-Approval (for individual tasks)
- [ ] All checklist items above are completed
- [ ] Documentation verification script passes
- [ ] Personal review of all changes is satisfactory
- [ ] Confidence level is high for production deployment

### Team Approval (for significant changes)
- [ ] Code review completed by team member
- [ ] Documentation review completed by appropriate team member
- [ ] Product owner approval for user-facing changes
- [ ] Architecture review for structural changes

## Post-Completion Actions

### Immediate Actions
- [ ] Update task status in project management system
- [ ] Commit all changes with descriptive commit messages
- [ ] Create pull request if working on feature branch
- [ ] Tag or label the work appropriately

### Communication
- [ ] Notify team of task completion
- [ ] Update stakeholders on user-facing changes
- [ ] Document any lessons learned or important implementation notes
- [ ] Schedule demo or review session if appropriate

## Emergency Override

In exceptional circumstances where documentation verification must be bypassed:

### Override Process
1. **Document Justification**: Clear reason why documentation cannot be updated immediately
2. **Create Tracking Ticket**: Ensure documentation debt is tracked for future resolution
3. **Use Force Override**: `./core/scripts/task-completion-check.sh --force`
4. **Set Reminder**: Schedule documentation update within specific timeframe

### Override Requirements
- [ ] Emergency nature of change is documented
- [ ] Documentation debt ticket created and prioritized
- [ ] Team lead or product owner approval obtained
- [ ] Planned timeline for documentation update established

## Quality Gates

### Before Marking Complete
- **MUST PASS**: Documentation verification script
- **MUST PASS**: All automated tests
- **SHOULD PASS**: Code quality checks
- **SHOULD HAVE**: Peer review for significant changes

### Documentation Quality Standards
- **Accuracy**: Documentation reflects actual implementation
- **Completeness**: All user-facing changes are documented
- **Clarity**: Documentation is clear and actionable
- **Currency**: Documentation is up-to-date with latest changes

## Notes

- This checklist supports the documentation-as-you-go workflow
- Documentation verification is mandatory for task completion
- Use the automated verification script as the primary verification method
- Emergency overrides should be rare and well-documented
- Documentation quality is as important as code quality

