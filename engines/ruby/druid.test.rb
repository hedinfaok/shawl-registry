#!/usr/bin/env ruby
# Test file for druid mode - defines testable functions

def test_function
  print("DRUID_MODE_TEST_PASSED")
  puts
end

def test_with_args(*args)
  puts "ARGS: #{args.join(' ')}"
end
