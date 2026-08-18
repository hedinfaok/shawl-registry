// Test file for druid mode - defines testable functions

function test_function() {
    console.log("DRUID_MODE_TEST_PASSED");
}

function test_with_args(...args: string[]) {
    console.log("ARGS: " + args.join(" "));
}

// Deno ES modules expose these via named exports so druid can import them.
export { test_function, test_with_args };
