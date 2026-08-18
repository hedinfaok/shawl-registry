#!/usr/bin/env node
// Test file for shebang mode - uses shebang for execution

const args = process.argv.slice(2);

console.log("SHEBANG_MODE_TEST_PASSED");

if (args.length > 0) {
    console.log("ARGS: " + args.join(" "));
}
