#!/usr/bin/env bash
# Example test script for Shawl

function hello() {
    echo "Hello from bash function!"
    echo "Arguments: $*"
}

function test_vars() {
    echo "SHAWL_FILEPATH: $SHAWL_FILEPATH"
    echo "SHAWL_BASENAME: $SHAWL_BASENAME"
    echo "SHAWL_MODE: $SHAWL_MODE"
}

function run_tests() {
    echo "Running tests..."
    echo "Test 1: Pass"
    echo "Test 2: Pass"
    echo "All tests passed!"
}

# If executed directly (exec/shebang mode)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Script executed directly"
    echo "Args: $*"
fi
