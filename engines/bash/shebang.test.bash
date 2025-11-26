#!/bin/bash
# Test file for shebang mode - uses shebang for execution

echo "SHEBANG_MODE_TEST_PASSED"

if [ $# -gt 0 ]; then
    echo "ARGS: $*"
fi
