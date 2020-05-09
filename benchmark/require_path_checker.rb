# frozen-string-literal: true
#
# Run the following command to run this script:
#
#   $ ruby --disable-did_you_mean benchmark/require_path_checker.rb
#

require_relative '../lib/did_you_mean/spell_checkers/require_path_checker'

require 'benchmark/ips'

Benchmark.ips do |x|
  x.config(time: 10, warmup: 10)

  exception_with_slash = begin
                           require 'net/htto'
                         rescue LoadError => error
                           error
                         end

  exception_without_slash = begin
                              require 'net-http'
                            rescue LoadError => error
                              error
                            end

  checker_for_path = DidYouMean::RequirePathChecker.new(exception_with_slash)
  checker_for_file = DidYouMean::RequirePathChecker.new(exception_without_slash)

  x.report "original (with a /)" do
    checker_for_path.corrections
  end

  x.report "original (without /)" do
    checker_for_file.corrections
  end

  #x.report "proposed (with a /)" do
  #  checker_for_path.experiment
  #end
  #
  #x.report "proposed (without /)" do
  #  checker_for_file.experiment
  #end

  x.compare!
end
