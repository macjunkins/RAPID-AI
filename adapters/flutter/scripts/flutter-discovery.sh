#!/bin/bash

# Flutter-specific story discovery using AI
# Extracted from EmberCare's specific implementation patterns

set -e

# Load framework core functions
SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/../../../core/workflows/common-functions.sh"

# Flutter-specific configuration
FLUTTER_CONFIG_FILE="pubspec.yaml"
BLOC_PATTERN_ENABLED=true
DRIFT_ENABLED=true

# Generate Flutter-specific AI prompt (extracted from EmberCare)
generate_flutter_prompt() {
    local epic=$1
    local story=$2
    local title=$3
    
    # This is the exact prompt pattern that works well for EmberCare
    local prompt="Read docs/prd.md and find Story $epic.$story: $title.

For this Flutter story using BLoC + Drift architecture, provide:

1. **Story Requirements Summary**
   - Core functionality needed
   - User acceptance criteria
   - Business rules and constraints

2. **Drift Table Definition**
   - Complete table schema with proper column types
   - Relationships and foreign keys
   - Enums and custom types needed
   - Migration considerations

3. **BLoC Events/States Required**
   - Event classes for user actions
   - State classes for UI representation
   - Error states and loading states
   - State transitions and business logic

4. **UI Components to Build**
   - Page/screen structure
   - Widget hierarchy
   - GruvBox Dark theme integration (if applicable)
   - Accessibility considerations

5. **Testing Approach**
   - Unit tests for BLoC logic
   - Widget tests for UI components
   - Integration tests for workflows
   - Test data and mocking strategy

6. **Implementation Files List**
   - Specific file paths in lib/ structure
   - Dependencies to add to pubspec.yaml
   - Code generation requirements

Keep response concise, actionable, and specific to Flutter/Dart patterns."

    echo "$prompt"
}

# Flutter-specific post-processing (from EmberCare experience)
post_process_flutter_discovery() {
    local file=$1
    
    # Add Flutter-specific reminders based on EmberCare learnings
    cat >> "$file" << 'EOF'

---

## Flutter-Specific Reminders

### After Creating/Modifying Drift Tables
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Dependencies Check
Ensure these are in `pubspec.yaml`:
- `flutter_bloc` for state management
- `drift` for database
- `equatable` for value equality
- `get_it` for dependency injection

### Architecture Patterns
- Follow BLoC pattern: Events → States → UI
- Use repository pattern for data access
- Inject dependencies via get_it
- Keep business logic in BLoCs, not widgets

### Testing Requirements
- Test BLoCs with `bloc_test` package
- Mock repositories with `mocktail`
- Test widgets with `flutter_test`
- Verify database operations with test database

### File Structure (EmberCare Pattern)
```
lib/
├── core/           # DI, routing, theme, utils
├── data/           # Database, repositories
├── domain/         # Entities, enums (pure Dart)
├── presentation/   # BLoCs, pages, widgets
└── main.dart       # Entry point
```

### Code Generation Reminder
Always run after schema changes:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

EOF

    echo "📱 Flutter-specific analysis complete: $file"
}

# Override the main discovery function for Flutter
run_flutter_discovery() {
    local epic=$1
    local story=$2
    local title=$3
    local output_file=$4
    
    echo "📱 Running Flutter-specific AI analysis for Story $epic.$story: $title"
    
    # Set Flutter as project type
    PROJECT_TYPE="flutter"
    
    # Generate Flutter-optimized prompt
    local prompt=$(generate_flutter_prompt "$epic" "$story" "$title")
    
    # Run AI analysis with Flutter context
    AI_TOOL="${AI_TOOL:-copilot}"
    run_ai_analysis "$AI_TOOL" "$prompt" "$output_file" "${TIMEOUT:-120}"
    
    # Add Flutter-specific post-processing
    post_process_flutter_discovery "$output_file"
}

# Main execution for Flutter adapter
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    # Called directly - run Flutter discovery
    run_flutter_discovery "$1" "$2" "$3" "$4"
fi