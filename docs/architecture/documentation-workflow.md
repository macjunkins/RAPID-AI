# Documentation Workflow Architecture

**Status:** Implemented
**Version:** 1.0
**Last Updated:** 2025-10-23

---

## Overview

The RAPID-AI documentation workflow provides automated documentation verification integrated directly into the development process. This ensures that user-facing documentation stays current with code changes without disrupting existing AI analysis workflows.

**Key Principle:** Documentation features are **enhancements**, not replacements. All documentation capabilities can be enabled/disabled via configuration, preserving existing RAPID-AI functionality.

---

## Architecture Pattern: Progressive Enhancement

### Enhancement Levels

The documentation workflow provides three progressive enhancement levels:

#### Level 1: Detection (Informational Only)
- **What:** Identifies when documentation needs updating
- **Impact:** No workflow changes, informational feedback only
- **Configuration:** `documentation_workflow.detection.enabled: true`
- **Use Case:** Get documentation recommendations without enforcement

#### Level 2: AI-Powered Suggestions (Guidance)
- **What:** AI analyzes documentation gaps and suggests improvements
- **Impact:** Enhanced feedback with actionable recommendations
- **Configuration:** `documentation_workflow.ai_analysis.enabled: true`
- **Use Case:** Leverage AI for comprehensive documentation analysis

#### Level 3: Completion Gate (Enforcement)
- **What:** Blocks task completion when critical documentation gaps exist
- **Impact:** Mandatory documentation verification before completion
- **Configuration:** `documentation_workflow.completion_gate.enabled: true`
- **Use Case:** Enforce documentation quality standards

### Default Configuration

**By default, RAPID-AI uses Level 1 + Level 2 WITHOUT enforcement:**

```yaml
documentation_workflow:
  enabled: true  # Enable documentation features
  detection:
    enabled: true  # Detect documentation needs
  ai_analysis:
    enabled: true  # Get AI suggestions
  completion_gate:
    enabled: false  # Don't block completion (progressive enhancement)
```

This ensures backward compatibility while providing documentation guidance.

---

## Three-Layer Architecture Integration

### Core Layer (`core/`)

**Documentation Detection:**
- `core/scripts/doc-detection.sh` - Pattern-based documentation requirement detection
- Analyzes file changes (git diff, specific files, or directory)
- Maps file patterns to documentation requirements
- Supports multiple analysis modes (detect, suggest, analyze-ai, verify)

**Task Completion Verification:**
- `core/scripts/task-completion-verification.sh` - Validates documentation currency
- Runs documentation verification checklist
- Configurable blocking based on severity levels
- Integrates with VS Code task completion workflow

**Workflow Integration:**
- `core/scripts/workflow-integration.sh` - Enhanced workflows with documentation
- Wraps existing AI analysis with documentation detection
- Adds documentation sections to discovery and planning outputs
- Maintains compatibility with existing workflows

**Common Functions:**
- `core/workflows/common-functions.sh` - Documentation utility functions
- AI integration for documentation analysis
- Environment-aware progress indicators
- Configuration loading and validation

**Checklists:**
- `core/checklists/documentation-currency-checklist.md` - Systematic verification
- Generalized from BMAD patterns for any project type
- Comprehensive validation across all documentation dimensions
- Severity-based prioritization (critical/major/minor)

### Adapter Layer (`adapters/`)

**Flutter Adapter Integration:**
- `adapters/flutter/config/doc-mapping.yaml` - Flutter-specific documentation mapping
- Maps BLoC/Drift/UI changes to relevant documentation
- EmberCare-compatible patterns and conventions
- Severity mapping for Flutter file types

**Flutter Discovery Enhancement:**
- `adapters/flutter/scripts/flutter-discovery.sh` - Enhanced with doc detection
- Adds Flutter-specific documentation requirements to discovery output
- Maintains EmberCare backward compatibility
- Non-breaking enhancement (additive only)

**Future Adapters:**
- React, Python, Go adapters will follow same enhancement pattern
- Each adapter defines project-type specific documentation mappings
- Adapters enhance without replacing core functionality

### Template Layer (`templates/`)

**VS Code Tasks:**
- 6 documentation-aware task variants (analysis, planning, completion with docs)
- 4 documentation helper tasks (status check, guidelines, interactive helper)
- Problem matchers for documentation issues (`📋 Documentation required:`)
- Progress indicators show documentation status

**Configuration:**
- `.ai-workflow.yaml` schema includes `documentation_workflow` section
- Configurable detection, AI analysis, and completion gate settings
- Severity level definitions (critical/major/minor)
- Reporting and integration options

---

## Configuration-Driven Behavior

### Severity Levels

Documentation gaps are classified by severity:

#### Critical (Blocks Completion When Gate Enabled)
- User-facing changes without documentation
- Breaking changes not documented
- API modifications lacking documentation
- New configuration options undocumented

#### Major (Warnings, Should Address)
- Workflow changes not documented
- Integration modifications undocumented
- Code examples no longer working

#### Minor (Informational, Can Defer)
- Formatting inconsistencies
- Minor documentation inaccuracies
- Enhancement opportunities

### Enforcement Configuration

Control when documentation verification blocks task completion:

```yaml
completion_gate:
  enabled: false  # Master switch
  enforce_on_critical: true  # Block for critical gaps
  enforce_on_major: false  # Warn for major gaps
  enforce_on_minor: false  # Inform about minor gaps
```

**Flexible Enforcement Examples:**

**Strict Mode (Enforce All):**
```yaml
completion_gate:
  enabled: true
  enforce_on_critical: true
  enforce_on_major: true
  enforce_on_minor: false
```

**Balanced Mode (Enforce Critical Only - Recommended):**
```yaml
completion_gate:
  enabled: true
  enforce_on_critical: true
  enforce_on_major: false
  enforce_on_minor: false
```

**Informational Mode (No Enforcement - Default):**
```yaml
completion_gate:
  enabled: false
  # No blocking, only informational feedback
```

---

## Integration Points

### AI Integration

**GitHub Copilot CLI:**
- Primary AI tool for documentation analysis
- Timeout protection prevents hanging
- Graceful degradation if AI unavailable
- Programmatic mode (`copilot -p "prompt" --allow-all-tools`)

**AI Analysis Capabilities:**
- Compare documentation against current implementation
- Identify documentation gaps and inconsistencies
- Generate documentation improvement suggestions
- Analyze documentation completeness

### VS Code Integration

**Problem Matchers:**
- Documentation requirements surfaced in Problems panel
- Pattern: `📋 Documentation required: <details>`
- Pattern: `🚫 Documentation not current: <details>`
- Severity: Warning (doesn't break build)

**Progress Indicators:**
- Documentation status in task execution feedback
- Clear messaging about documentation requirements
- Interactive documentation helper for guidance
- File opening behavior respects VS Code context

### Git Integration

**Change Detection:**
- `git diff` analysis for documentation requirements
- File change tracking since last commit
- Unstaged/staged change differentiation
- Documentation mapping based on git history

---

## EmberCare Backward Compatibility

### Compatibility Guarantee

**100% Backward Compatibility Maintained:**
- Existing EmberCare scripts work unchanged
- Flutter adapter enhancements are additive only
- No modifications to core AI analysis flow
- Documentation features are optional enhancements

### EmberCare Integration

**Proven Patterns Preserved:**
- BLoC + Drift architecture analysis unchanged
- Flutter discovery prompt patterns maintained
- File structure conventions preserved
- Testing approach recommendations intact

**Enhanced Capabilities:**
- Flutter-specific documentation detection added
- BLoC/Drift/UI change documentation mapping
- EmberCare-compatible severity levels
- Repository pattern documentation guidance

### Migration Path

**EmberCare Projects Can:**
1. **Adopt Immediately:** Enable documentation features via config
2. **Test Gradually:** Use detection only (no enforcement)
3. **Roll Back Easily:** Disable via `documentation_workflow.enabled: false`
4. **Customize Fully:** Adjust severity levels and enforcement thresholds

---

## Performance Characteristics

### Non-Blocking Design

**Documentation Detection:**
- Runs AFTER successful AI analysis (doesn't slow down analysis)
- File pattern matching is fast (milliseconds)
- Git diff analysis uses cached git data
- No network calls for basic detection

**AI-Powered Analysis:**
- Respects timeout configuration (default: 60 seconds)
- Runs in background (doesn't block terminal)
- Progress indicators show elapsed time
- Graceful timeout handling with helpful messages

**Task Completion Verification:**
- Configurable (can skip if disabled)
- Checklist validation is fast (file reads only)
- AI verification is optional (can be disabled)
- No impact if `completion_gate.enabled: false`

### Performance Validation

**Existing Workflows Unchanged:**
- AI story analysis: Same performance (no impact)
- Implementation planning: Same performance (no impact)
- VS Code task execution: Minimal overhead (<100ms for detection)
- Git operations: No additional git calls (uses existing diff)

---

## Pattern Extraction from BMAD

### Successfully Adapted Patterns

**1. Documentation Detection Logic**
- BMAD: Agent-driven file tracking
- RAPID-AI: Shell script pattern matching
- Adaptation: POSIX-compatible, portable across environments

**2. Task Completion Gating**
- BMAD: Agent workflow blocking
- RAPID-AI: Configurable shell script verification
- Adaptation: Optional enforcement via configuration

**3. AI-Powered Analysis**
- BMAD: Agent communication system
- RAPID-AI: Shell script AI abstraction layer
- Adaptation: GitHub Copilot CLI integration with timeout protection

**4. Checklist-Driven Verification**
- BMAD: BMAD-specific checklist
- RAPID-AI: Generalized for any project type
- Adaptation: Project-type specific sections via adapters

**5. Workflow Integration**
- BMAD: Agent commands (`*validate-docs`, `*update-docs`)
- RAPID-AI: VS Code tasks and shell scripts
- Adaptation: Primary interface via VS Code tasks

### Key Differences

| Aspect | BMAD | RAPID-AI |
|--------|------|----------|
| Orchestration | Agent-driven | Shell script-driven |
| AI Integration | Agent communication | Shell script abstraction |
| Enforcement | Built-in | Configuration-driven |
| User Interface | Agent commands | VS Code tasks + CLI |
| Portability | BMAD-dependent | Standalone (POSIX) |
| Scope | BMAD-specific docs | Project-type specific |

---

## Usage Examples

### Example 1: Detect Documentation Needs

```bash
# Analyze current git changes for documentation requirements
./core/scripts/doc-detection.sh --git-diff

# Analyze specific files
./core/scripts/doc-detection.sh --files "core/scripts/ai-discovery.sh,adapters/flutter/config/doc-mapping.yaml"

# Get AI-powered documentation suggestions
./core/scripts/doc-detection.sh --suggest --files "lib/blocs/medication_bloc.dart"
```

### Example 2: Verify Documentation Currency

```bash
# Run documentation verification before task completion
./core/scripts/task-completion-verification.sh

# Run with AI-powered analysis
ENABLE_AI_ANALYSIS=true ./core/scripts/task-completion-verification.sh
```

### Example 3: Enhanced Workflows via VS Code

**Via Command Palette:**
1. Run "AI Workflow: Analyze Story with Documentation"
2. Review discovery output (includes documentation requirements)
3. Run "Documentation: Check Status" to see current gaps
4. Run "Documentation: Interactive Helper" for guidance

### Example 4: Flutter Project with Documentation

```bash
# Run Flutter discovery with documentation detection
./adapters/flutter/scripts/flutter-discovery.sh 1 4 "Medication Inventory" output.md

# Output includes:
# - Standard Flutter analysis (BLoC, Drift, UI, Testing)
# - Flutter Documentation Requirements section
# - EmberCare Compatibility Notes
# - Flutter-Specific Reminders
```

---

## Future Enhancements

### Planned Improvements

**1. Additional Adapters**
- React adapter with component/state management doc mapping
- Python adapter with API endpoint documentation
- Go adapter with package documentation

**2. Enhanced AI Analysis**
- Claude/GPT-4 integration for alternative AI tools
- Multi-AI comparison for comprehensive analysis
- Fine-tuned prompts per documentation type

**3. Automated Documentation Updates**
- AI-generated documentation patches
- Automated README updates for config changes
- Changelog generation from git history

**4. Team Collaboration**
- Documentation review workflows
- Team documentation assignments
- Documentation debt tracking dashboard

---

## Troubleshooting

### Documentation Detection Not Working

**Problem:** `doc-detection.sh` doesn't find documentation requirements

**Solutions:**
1. Check configuration: `documentation_workflow.detection.enabled: true`
2. Verify file patterns match in doc-mapping.yaml (for adapters)
3. Ensure git repository is initialized (for git-diff mode)
4. Check script has execute permissions: `chmod +x core/scripts/doc-detection.sh`

### AI Analysis Timing Out

**Problem:** Documentation AI analysis hangs or times out

**Solutions:**
1. Increase timeout: `documentation_workflow.ai_analysis.timeout: 120`
2. Check GitHub Copilot CLI is authenticated: `copilot auth status`
3. Simplify the analysis scope (fewer files)
4. Disable AI analysis temporarily: `ai_analysis.enabled: false`

### Completion Gate Blocking Unexpectedly

**Problem:** Task completion blocked when it shouldn't be

**Solutions:**
1. Check severity configuration matches expectations
2. Disable enforcement: `completion_gate.enabled: false`
3. Review gap assessment (may be legitimate block)
4. Adjust severity thresholds: `enforce_on_critical: true` only

---

## References

- **BMAD Pattern Extraction:** `.ai/pattern-extraction-task6.md`
- **Configuration Schema:** `.ai-workflow.yaml`
- **Flutter Adapter Mapping:** `adapters/flutter/config/doc-mapping.yaml`
- **Verification Checklist:** `core/checklists/documentation-currency-checklist.md`
- **Story Implementation:** `docs/stories/1.3.implement-documentation-as-you-go-workflow-integration.md`

---

**This architecture ensures documentation stays current while maintaining RAPID-AI's core mission: AI-powered development workflow automation without disrupting existing proven patterns.**
