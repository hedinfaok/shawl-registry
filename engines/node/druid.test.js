#!/usr/bin/env node
// Test file for druid mode - defines testable functions

function test_function() {
    console.log("DRUID_MODE_TEST_PASSED");
}

function test_with_args() {
    console.log("ARGS: " + Array.prototype.slice.call(arguments).join(" "));
}

module.exports = {
    test_function: test_function,
    test_with_args: test_with_args
};
