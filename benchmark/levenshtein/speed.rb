require 'benchmark/ips'
require 'did_you_mean'

Benchmark.ips do |x|
  x.report "each_char" do
    DidYouMean::Levenshtein.before_distance "user_signed_in?", "user_logged_in?"
  end

  x.report "each_codepoint" do
    DidYouMean::Levenshtein.after_distance "user_signed_in?", "user_logged_in?"
  end

  x.compare!
end
