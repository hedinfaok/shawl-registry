#!/usr/bin/env -S deno run --allow-all
// Test file for shebang mode - uses shebang for execution

const args = Deno.args;

console.log("SHEBANG_MODE_TEST_PASSED");

if (args.length > 0) {
    console.log("ARGS: " + args.join(" "));
}
