#!/usr/bin/env node
// Test file for exec mode - standalone executable script

const args = process.argv.slice(2);

console.log("EXEC_MODE_TEST_PASSED");

if (args.length > 0) {
    console.log("ARGS: " + args.join(" "));
}
