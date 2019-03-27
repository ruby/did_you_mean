require 'test_helper'
require 'set'

class TreeSpellExploreTest  < Minitest::Test
  def test_human_typo_exercise
    n_repeat = 100
    first_times = [0, 0]
    total_suggestions = [0, 0]
    total_failures = [0, 0]
    files = Dir['test/**/*.rb']
    len = files.length
    n_repeat.times do
      word = files[rand len]
      word_error = HumanTypo.new(word).call
      suggestions_a = group_suggestions word_error, files
      check_first_is_right word, suggestions_a, first_times
      check_no_suggestions suggestions_a, total_suggestions
      check_for_failure word, suggestions_a, total_failures
    end
    print_results first_times, total_suggestions, total_failures, n_repeat
  end

  private

  def print_results(first_times, total_suggestions, total_failures, n_repeat)
   algorithms = %w(Tree DYM_ Comb)
    pp "                         Summary "
    pp "----------------------------------------------------------------------------------"
    pp " Method  |   First Time (\%)    Mean Suggestions       Failures (\%)"
    pp "----------------------------------------------------------------------------------"
    (0..1).each do |i|
      ft = (first_times[i].to_f / n_repeat * 100).round(1)
      mns = (total_suggestions[i].to_f / (n_repeat)).round(2)
      f = (total_failures[i].to_f / n_repeat * 100).round(1)
      pp " #{algorithms[i]}          #{ft}                  #{mns}                 #{f}"
    end
  end

  def group_suggestions(word_error, files)
    a0 = TreeSpellChecker.new(dictionary: files).correct word_error
    a1 = ::DidYouMean::SpellChecker.new(dictionary: files).correct word_error
    [a0, a1]
  end

  def check_for_failure(word, suggestions_a, total_failures)
    suggestions_a.each_with_index.map do |a, i|
      total_failures[i] += 1 unless a.include? word
    end
  end

  def check_first_is_right(word, suggestions_a, first_times)
    suggestions_a.each_with_index.map do |a, i|
      first_times[i] += 1 if word == a.first
    end
  end

  def check_no_suggestions(suggestions_a, total_suggestions)
    suggestions_a.each_with_index.map do |a, i|
      total_suggestions[i] += a.length
    end
  end
end
