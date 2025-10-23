# VS Code Tasks for RAPID-AI

This directory contains VS Code task definitions that provide the primary interface for RAPID-AI's AI-powered SDLC workflows.

## Enhanced Documentation Integration

All tasks now include integrated documentation verification to ensure documentation stays current with development activities.

## Available Task Categories

### Core AI Workflow Tasks

- **AI Workflow: Analyze Story** - Analyze story requirements with AI assistance
- **AI Workflow: Generate Implementation Plan** - Generate implementation plan with AI
- **AI Workflow: Flutter Analysis** - Flutter-specific analysis using EmberCare adapter
- **AI Workflow: Complete Story Setup** - Complete workflow sequence

### Documentation-Aware Tasks

Enhanced tasks that integrate documentation verification:

- **Documentation: Analyze Story with Documentation** - Story analysis with documentation detection
- **Documentation: Generate Implementation Plan with Documentation** - Planning with documentation requirements
- **Documentation: Verify Task Completion** - Task completion with documentation verification
- **Documentation: Complete Task with Documentation Verification** - Task completion with mandatory documentation checks
- **Documentation: Check Documentation Requirements** - Check what documentation needs updating
- **Documentation: Complete Story Setup with Documentation** - Complete documentation-aware workflow

### Documentation Helper Tasks

- **Documentation: Quick Documentation Status Check** - Quick status check for current story
- **Documentation: Show Documentation Guidelines** - Display documentation best practices
- **Documentation: Interactive Documentation Update Helper** - Interactive guidance for documentation updates

## Documentation Integration Features

### Problem Matchers

Tasks include specialized problem matchers to surface documentation issues in VS Code:

- `📋 Documentation required:` - Files requiring documentation updates
- `📝 Documentation issue:` - Documentation problems blocking completion
- `🚫 Documentation not current` - Documentation verification failures

### Progress Indicators

Enhanced task presentation includes:
- **Detail fields** - Clear descriptions of what each task does
- **Enhanced error detection** - Documentation-specific error patterns
- **Status integration** - Visual progress indicators for documentation requirements

### Input Parameters

Tasks use parameterized inputs for consistency:
- `epic` - Epic number
- `story` - Story number  
- `title` - Story title
- `storySlug` - URL-friendly story identifier
- `taskId` - Task identifier for completion tracking
- `changedFiles` - Files modified during development

## Usage

1. **Open Command Palette**: `Cmd+Shift+P` (macOS) / `Ctrl+Shift+P` (Windows/Linux)
2. **Search for**: "Tasks: Run Task"
3. **Select**: Any documentation-aware task
4. **Follow prompts**: Enter epic number, story number, and title when prompted

## Documentation Verification Process

1. **Analysis Phase** - Tasks detect what documentation needs updating
2. **Planning Phase** - Documentation requirements integrated into implementation plan
3. **Implementation Phase** - Documentation verification runs with task completion
4. **Completion Phase** - Tasks cannot be marked complete until documentation is current

## Integration with Existing Workflows

Documentation-aware tasks enhance rather than replace existing RAPID-AI functionality:
- Maintains 100% EmberCare adapter compatibility
- Preserves existing AI analysis performance
- Enhances VS Code task progress indicators
- Adds documentation guidance without changing core analysis

## Troubleshooting

### Task Completion Blocked

If task completion is blocked due to documentation issues:

1. Run **Documentation: Check Documentation Requirements**
2. Update identified documentation files
3. Run **Documentation: Verify Task Completion** 
4. Use **Documentation: Interactive Documentation Update Helper** for guidance

### Documentation Detection Issues

If documentation detection isn't working correctly:

1. Check that `core/scripts/doc-detection.sh` is executable
2. Verify file paths in task definitions match your project structure
3. Review documentation patterns in the detection script

## File Structure

```
templates/vscode/
├── tasks.json          # VS Code task definitions
└── README.md          # This documentation file
```

Tasks call scripts in:
- `core/scripts/` - Core SDLC automation scripts
- `core/workflows/` - Shared workflow utilities
- `adapters/` - Project-specific implementations

## Development

When modifying VS Code tasks:

1. Update task definitions in `tasks.json`
2. Test with **Documentation: Quick Documentation Status Check**
3. Update this README if adding new task categories
4. Verify problem matchers work correctly with new output patterns
