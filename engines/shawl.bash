#!/bin/bash
# Shawl shim script for bash engine
# This script provides helper functions for the shim mode

function list() {
    # List all scripts in SHAWL_PATH
    IFS=':' read -ra PATHS <<< "$SHAWL_PATH"
    for dir in "${PATHS[@]}"; do
        if [[ -d "$dir" ]]; then
            echo "Scripts in $dir:"
            find "$dir" -maxdepth 1 -type f ! -name "*.toml" ! -name "*.tpl" -exec basename {} \; | sort
        fi
    done
}

function info() {
    # Display detailed information about a script
    local script="$1"
    if [[ -z "$script" ]]; then
        echo "Usage: shim shawl.bash info <script>"
        return 1
    fi
    
    # Find script in path
    IFS=':' read -ra PATHS <<< "$SHAWL_PATH"
    local found=0
    for dir in "${PATHS[@]}"; do
        if [[ -f "$dir/$script" ]]; then
            found=1
            echo "Script: $script"
            echo "Path: $dir/$script"
            echo "Size: $(wc -c < "$dir/$script") bytes"
            echo "Lines: $(wc -l < "$dir/$script")"
            echo "Executable: $(test -x "$dir/$script" && echo "yes" || echo "no")"
            
            # Extract shebang
            local shebang
            shebang=$(head -n 1 "$dir/$script")
            if [[ "$shebang" =~ ^#! ]]; then
                echo "Shebang: $shebang"
            fi
            
            # List functions (bash-specific)
            echo "Functions:"
            grep -E "^function [a-zA-Z_][a-zA-Z0-9_]*|^[a-zA-Z_][a-zA-Z0-9_]*\(\)" "$dir/$script" | head -10
            
            return 0
        fi
    done
    
    if [[ $found -eq 0 ]]; then
        echo "Script not found: $script"
        return 1
    fi
}

function validate() {
    # Validate a script's syntax
    local script="$1"
    if [[ -z "$script" ]]; then
        echo "Usage: shawl shim shawl.bash validate <script>"
        return 1
    fi
    
    # Find script
    IFS=':' read -ra PATHS <<< "$SHAWL_PATH"
    for dir in "${PATHS[@]}"; do
        if [[ -f "$dir/$script" ]]; then
            echo "Validating $script..."
            bash -n "$dir/$script"
            if [[ $? -eq 0 ]]; then
                echo "✓ Syntax is valid"
                return 0
            else
                echo "✗ Syntax errors found"
                return 1
            fi
        fi
    done
    
    echo "Script not found: $script"
    return 1
}

# Execute the requested function
# Function name comes as first positional argument in shim mode
FUNCTION_NAME="${1:-$SHAWL_FUNCTION}"

if [[ -n "$FUNCTION_NAME" ]]; then
    shift  # Remove function name from args
    "$FUNCTION_NAME" "$@"
else
    echo "Available shim functions:"
    echo "  list      - List all scripts"
    echo "  info      - Show script information"
    echo "  validate  - Validate script syntax"
fi
