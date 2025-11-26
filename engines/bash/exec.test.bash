#!/bin/bash
# Test file for exec mode - standalone executable script

echo "EXEC_MODE_TEST_PASSED"

if [ $# -gt 0 ]; then
    echo "ARGS: $*"
fi
