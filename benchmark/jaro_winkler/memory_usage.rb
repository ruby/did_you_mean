# frozen-string-literal: true

require 'memory_profiler'
require 'did_you_mean/jaro_winkler'

report = MemoryProfiler.report do
  80.times do
    DidYouMean::Jaro.distance "user_signed_in?", "user_logged_in?"
  end
end

report.pretty_print
