#!/bin/bash

# De-brand BMAD task files for RAPID-AI
# Process all .md files from .bmad-core/tasks/ to src/rapid/tasks/

SOURCE_DIR="/Users/johnjunkins/GitHub/RAPID-AI/.bmad-core/tasks"
TARGET_DIR="/Users/johnjunkins/GitHub/RAPID-AI/src/rapid/tasks"

# Create target directory
mkdir -p "$TARGET_DIR"

# Counter for processed files
processed=0
failed=0

echo "Starting de-branding process..."
echo "Source: $SOURCE_DIR"
echo "Target: $TARGET_DIR"
echo ""

# Process each .md file
for source_file in "$SOURCE_DIR"/*.md; do
    # Get filename
    filename=$(basename "$source_file")
    target_file="$TARGET_DIR/$filename"

    echo "Processing: $filename"

    # Apply transformations using sed
    sed -e 's/<!-- Powered by BMAD™ Core -->//g' \
        -e 's/## <!-- Powered by BMAD™ Core -->//g' \
        -e 's/\.bmad-core\//src\/rapid\//g' \
        -e 's/bmad-core\//src\/rapid\//g' \
        -e 's/\.bmad-infrastructure-devops\//src\/rapid\//g' \
        -e 's/core-config\.yaml/rapid-config.yaml/g' \
        -e 's/\.bmad-core\/core-config\.yaml/src\/rapid\/rapid-config.yaml/g' \
        -e 's/BMAD™/RAPID-AI/g' \
        -e 's/BMad/RAPID/g' \
        -e 's/BMAD/RAPID/g' \
        -e 's/\/bmad-master/\/rapid/g' \
        -e 's/\/bmad/\/rapid/g' \
        "$source_file" > "$target_file"

    # Check if file was created successfully
    if [ -f "$target_file" ]; then
        ((processed++))
        echo "  ✓ Created: $target_file"
    else
        ((failed++))
        echo "  ✗ Failed: $target_file"
    fi
    echo ""
done

echo "========================================="
echo "De-branding complete!"
echo "Files processed: $processed"
echo "Files failed: $failed"
echo "Target directory: $TARGET_DIR"
echo "========================================="
