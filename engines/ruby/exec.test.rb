#!/usr/bin/env ruby
# Test file for exec mode - standalone executable script

print("EXEC_MODE_TEST_PASSED")
puts

if ARGV.length > 0
  puts "ARGS: #{ARGV.join(' ')}"
end
