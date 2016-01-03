# -*- frozen-string-literal: true -*-

require 'memory_profiler'
require 'did_you_mean'

# public def foo; end
# error      = (self.fooo rescue $!)
# executable = -> { error.to_s }

class SpellChecker
  include DidYouMean::SpellCheckable

  def initialize(words)
    @words = words
  end

  def correct(input)
    @corrections, @input = nil, input
    corrections
  end

  def candidates
    { @input => @words }
  end
end

METHODS    = ''.methods
INPUT      = 'start_with?'
collection = SpellChecker.new(METHODS)
executable = proc { collection.correct(INPUT) }

GC.disable
MemoryProfiler.report { 100.times(&executable) }.pretty_print
