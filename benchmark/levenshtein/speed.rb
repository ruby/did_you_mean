# frozen-string-literal: true

require 'benchmark/ips'
require 'did_you_mean/levenshtein'

Benchmark.ips do |x|
  x.report "original" do
    DidYouMean::Levenshtein.distance "user_signed_in?", "user_logged_in?"
  end

  # This #proposed method is not defined. Write your own method using this
  # name so we can reliably run the benchmark and measure the difference.
  #
  # Alternatively, you could directly update the #distance method and remove
  # this completely.
  #
  # x.report "proposed" do
  #   DidYouMean::Levenshtein.proposed "user_signed_in?", "user_logged_in?"
  # end

  x.compare!
end
