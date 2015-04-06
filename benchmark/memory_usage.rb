require 'memory_profiler'
require_relative '../test/test_helper'

def foo; end
public :foo

error  = (self.fooo rescue $!)
report = MemoryProfiler.report do
  100.times { error.to_s }
end

report.pretty_print
