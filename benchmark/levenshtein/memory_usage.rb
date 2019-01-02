# frozen-string-literal: true

require 'memory_profiler'
require 'did_you_mean/levenshtein'

report = MemoryProfiler.report do
  1000.times do
    DidYouMean::Levenshtein.distance "user_signed_in?", "user_logged_in?"
  end
end

report.pretty_print
