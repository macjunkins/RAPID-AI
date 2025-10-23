#!/bin/bash

# Document Generator Workflow
# Extracted from BMAD systematic workflows
# Adapted for RAPID-AI direct AI integration

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
TEMPLATES_DIR="${SCRIPT_DIR}/templates"
OUTPUT_DIR="${PROJECT_ROOT}/docs"

print_status() {
    local message="$1"
    echo "📄 ${message}"
}

list_available_templates() {
    print_status "Available document templates:"
    echo ""
    
    local count=1
    for template in "${TEMPLATES_DIR}"/*.md; do
        if [ -f "$template" ]; then
            local name=$(basename "$template" .md)
            echo "  ${count}. ${name}"
            count=$((count + 1))
        fi
    done
    echo ""
}

prompt_for_template_variables() {
    local template_file="$1"
    local output_file="$2"
    
    print_status "Gathering template variables..."
    
    # Extract variables from template ({{VARIABLE_NAME}} format)
    local variables=$(grep -o '{{[^}]*}}' "$template_file" | sort -u | sed 's/{{//g' | sed 's/}}//g')
    
    # Create temporary file to store variable values
    local vars_file="/tmp/rapid-ai-vars-$(date +%s).txt"
    
    echo "# Template Variables" > "$vars_file"
    echo "# Generated for: $(basename "$template_file")" >> "$vars_file"
    echo "" >> "$vars_file"
    
    for var in $variables; do
        echo -n "Enter value for ${var}: "
        read -r value
        echo "${var}=${value}" >> "$vars_file"
    done
    
    echo "$vars_file"
}

generate_document_from_template() {
    local template_file="$1"
    local output_file="$2"
    local vars_file="$3"
    
    print_status "Generating document from template..."
    
    # Copy template to output
    cp "$template_file" "$output_file"
    
    # Replace variables with values
    while IFS='=' read -r var value; do
        if [[ ! "$var" =~ ^#.* ]] && [ -n "$var" ]; then
            # Handle special variables
            case "$var" in
                "DATE")
                    value=$(date +%Y-%m-%d)
                    ;;
                "AUTHOR")
                    if [ -z "$value" ]; then
                        value="RAPID-AI Generator"
                    fi
                    ;;
            esac
            
            # Replace in output file
            sed -i.bak "s/{{${var}}}/${value}/g" "$output_file"
        fi
    done < "$vars_file"
    
    # Clean up backup file
    rm -f "${output_file}.bak"
    
    # Clean up variables file
    rm -f "$vars_file"
    
    print_status "Document generated: $output_file"
}

interactive_document_generation() {
    print_status "Interactive Document Generation"
    echo ""
    
    list_available_templates
    
    echo -n "Select template number: "
    read -r template_num
    
    local template_files=("${TEMPLATES_DIR}"/*.md)
    local selected_template="${template_files[$((template_num - 1))]}"
    
    if [ ! -f "$selected_template" ]; then
        echo "❌ Invalid template selection"
        return 1
    fi
    
    local template_name=$(basename "$selected_template" .md)
    echo -n "Enter output filename (without extension): "
    read -r output_name
    
    local output_file="${OUTPUT_DIR}/${output_name}.md"
    
    # Ensure output directory exists
    mkdir -p "$(dirname "$output_file")"
    
    # Check if file exists
    if [ -f "$output_file" ]; then
        echo -n "File exists. Overwrite? (y/n): "
        read -r confirm
        if [ "$confirm" != "y" ]; then
            echo "❌ Generation cancelled"
            return 1
        fi
    fi
    
    # Gather variables and generate
    local vars_file=$(prompt_for_template_variables "$selected_template" "$output_file")
    generate_document_from_template "$selected_template" "$output_file" "$vars_file"
    
    echo ""
    print_status "Document generation complete!"
    print_status "Generated: $output_file"
    
    # Open in VS Code if available
    if [[ "$TERM_PROGRAM" == "vscode" ]] && command -v code >/dev/null 2>&1; then
        echo -n "Open in VS Code? (y/n): "
        read -r open_code
        if [ "$open_code" == "y" ]; then
            code "$output_file"
            print_status "Opened in VS Code"
        fi
    fi
}

batch_document_generation() {
    local template_name="$1"
    local output_name="$2"
    local vars_string="$3"
    
    local template_file="${TEMPLATES_DIR}/${template_name}.md"
    local output_file="${OUTPUT_DIR}/${output_name}.md"
    
    if [ ! -f "$template_file" ]; then
        echo "❌ Template not found: $template_file"
        return 1
    fi
    
    # Create temporary variables file
    local vars_file="/tmp/rapid-ai-vars-$(date +%s).txt"
    echo "# Batch Variables" > "$vars_file"
    
    # Parse variables string (format: VAR1=value1,VAR2=value2)
    IFS=',' read -ra VARS <<< "$vars_string"
    for var_pair in "${VARS[@]}"; do
        echo "$var_pair" >> "$vars_file"
    done
    
    # Ensure output directory exists
    mkdir -p "$(dirname "$output_file")"
    
    generate_document_from_template "$template_file" "$output_file" "$vars_file"
}

main() {
    local mode="${1:-interactive}"
    
    print_status "Starting document generation workflow..."
    
    case "$mode" in
        "list")
            list_available_templates
            ;;
        "interactive")
            interactive_document_generation
            ;;
        "batch")
            local template_name="$2"
            local output_name="$3"
            local vars_string="$4"
            
            if [ -z "$template_name" ] || [ -z "$output_name" ]; then
                echo "Usage: $0 batch <template_name> <output_name> [variables]"
                echo "Variables format: VAR1=value1,VAR2=value2"
                exit 1
            fi
            
            batch_document_generation "$template_name" "$output_name" "$vars_string"
            ;;
        *)
            echo "Usage: $0 [list|interactive|batch]"
            echo "  list        - List available templates"
            echo "  interactive - Interactive document generation (default)"
            echo "  batch       - Batch document generation"
            exit 1
            ;;
    esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi