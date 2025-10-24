#!/usr/bin/env python3
"""
Transform BMAD template files to RAPID-AI templates.

Performs the following transformations:
1. Remove branding headers
2. Update template metadata (id, framework, version)
3. Update file path references
4. Update branding text
5. Update slash command references
"""

import os
import re
from pathlib import Path

# Source and destination directories
SOURCE_DIR = Path("/Users/johnjunkins/GitHub/RAPID-AI/.bmad-core/templates")
DEST_DIR = Path("/Users/johnjunkins/GitHub/RAPID-AI/src/rapid/templates")

# Template files to process
TEMPLATE_FILES = [
    "architecture-tmpl.yaml",
    "brainstorming-output-tmpl.yaml",
    "brownfield-architecture-tmpl.yaml",
    "brownfield-prd-tmpl.yaml",
    "competitor-analysis-tmpl.yaml",
    "front-end-architecture-tmpl.yaml",
    "front-end-spec-tmpl.yaml",
    "fullstack-architecture-tmpl.yaml",
    "market-research-tmpl.yaml",
    "prd-tmpl.yaml",
    "project-brief-tmpl.yaml",
    "qa-gate-tmpl.yaml",
    "story-tmpl.yaml",
]


def transform_content(content: str, filename: str) -> str:
    """Apply all transformations to the template content."""

    # 1. Remove branding headers
    content = re.sub(r'^# <!-- Powered by BMAD™ Core -->\n', '', content, flags=re.MULTILINE)
    content = re.sub(r'^<!-- Powered by BMAD™ Core -->\n', '', content, flags=re.MULTILINE)

    # 2. Update template metadata
    # Remove -v2 version suffix from template IDs
    content = re.sub(r'(id: \w+)-template-v2', r'\1-template', content)

    # Add framework field after version if not present
    if 'framework:' not in content:
        content = re.sub(r'(version: \d+\.\d+)', r'\1\n  framework: RAPID-AI', content, count=1)

    # Update version from 2.0 to 3.0 (or add if missing)
    content = re.sub(r'version: 2\.0', 'version: 3.0', content)
    if 'version:' not in content and 'template:' in content:
        # Add version if missing (after name)
        content = re.sub(r'(name: [^\n]+)', r'\1\n  version: 3.0\n  framework: RAPID-AI', content, count=1)

    # 3. Update file path references
    content = content.replace('.bmad-core/', 'src/rapid/')
    content = content.replace('bmad-core/', 'src/rapid/')

    # 4. Update branding text
    content = content.replace('BMAD™', 'RAPID-AI')
    content = content.replace('BMad', 'RAPID')
    content = content.replace('BMAD', 'RAPID')

    # 5. Update slash command references
    content = content.replace('/bmad-master', '/rapid')
    content = content.replace('/bmad', '/rapid')

    # Handle special case for session facilitation footer
    content = content.replace('RAPID-METHOD™', 'RAPID-AI')
    content = content.replace('RAPID™', 'RAPID-AI')

    return content


def process_templates():
    """Process all template files."""

    # Create destination directory if it doesn't exist
    DEST_DIR.mkdir(parents=True, exist_ok=True)

    processed_files = []

    for filename in TEMPLATE_FILES:
        source_path = SOURCE_DIR / filename
        dest_path = DEST_DIR / filename

        if not source_path.exists():
            print(f"⚠️  Source file not found: {filename}")
            continue

        # Read source file
        with open(source_path, 'r', encoding='utf-8') as f:
            content = f.read()

        # Transform content
        transformed_content = transform_content(content, filename)

        # Write to destination
        with open(dest_path, 'w', encoding='utf-8') as f:
            f.write(transformed_content)

        processed_files.append(filename)
        print(f"✓ Processed: {filename}")

    return processed_files


def main():
    """Main entry point."""
    print("=" * 60)
    print("BMAD → RAPID-AI Template Transformation")
    print("=" * 60)
    print()

    processed_files = process_templates()

    print()
    print("=" * 60)
    print("Summary")
    print("=" * 60)
    print(f"Total files processed: {len(processed_files)}")
    print(f"Destination: {DEST_DIR}")
    print()
    print("Processed files:")
    for filename in processed_files:
        print(f"  - {filename}")
    print()
    print("Transformations applied:")
    print("  - Removed BMAD™ branding headers")
    print("  - Updated template IDs (removed -v2 suffix)")
    print("  - Added framework: RAPID-AI field")
    print("  - Updated version to 3.0")
    print("  - Updated file paths (.bmad-core/ → src/rapid/)")
    print("  - Updated branding (BMAD → RAPID-AI)")
    print("  - Updated slash commands (/bmad → /rapid)")
    print()


if __name__ == "__main__":
    main()
