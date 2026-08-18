#!/usr/bin/env ruby
# Test file for shebang mode - uses shebang for execution

print("SHEBANG_MODE_TEST_PASSED")
puts

if ARGV.length > 0
  puts "ARGS: #{ARGV.join(' ')}"
end
