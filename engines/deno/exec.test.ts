// Test file for exec mode - standalone executable script

const args = Deno.args;

console.log("EXEC_MODE_TEST_PASSED");

if (args.length > 0) {
    console.log("ARGS: " + args.join(" "));
}
