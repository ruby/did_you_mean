require 'memory_profiler'
require 'did_you_mean'

# public def foo; end
# error      = (self.fooo rescue $!)
# executable = -> { error.to_s }

METHODS    = ''.methods
INPUT      = 'start_with?'
collection = DidYouMean::WordCollection.new(METHODS)
executable = proc { collection.similar_to(INPUT) }

MemoryProfiler.report { 100.times(&executable) }.pretty_print
