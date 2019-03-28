require 'test_helper'
require 'set'

class TreeSpellExploreTest  < Minitest::Test
  def test_checkers_with_human_typo_exercise
    n_repeat = 100
    first_times = [0, 0, 0]
    total_suggestions = [0, 0, 0]
    total_failures = [0, 0, 0]
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

  def test_human_typo
    n_repeat = 1000
    total_changes = 0
    word = 'any_string_that_is_40_characters_long_sp'
    n_repeat.times do
      word_error = HumanTypo.new(word).call
      total_changes += DidYouMean::Levenshtein.distance(word, word_error)
    end
    mean_changes = (total_changes.to_f / n_repeat).round(1)
    pp ''
    puts "HumanTypo mean_changes =  #{mean_changes}"
    pp ''
  end

  private

  def group_suggestions(word_error, files)
    a0 = TreeSpellChecker.new(dictionary: files).correct word_error
    a1 = ::DidYouMean::SpellChecker.new(dictionary: files).correct word_error
    a2 =  a0.empty? ? a1 : a0
    [a0, a1, a2]
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

  def print_results(first_times, total_suggestions, total_failures, n_repeat)
    algorithms = ['Tree    ', 'Standard', 'Combined']
    print_header
    (0..2).each do |i|
      ft = (first_times[i].to_f / n_repeat * 100).round(1)
      mns = (total_suggestions[i].to_f / (n_repeat - total_failures[i])).round(1)
      f = (total_failures[i].to_f / n_repeat * 100).round(1)
      pp " #{algorithms[i]}  #{' ' * 7}  #{ft} #{' ' * 14} #{mns} #{' ' * 15} #{f} #{' ' * 16}"
    end
  end

  def print_header
    pp "#{' ' * 33} Summary #{' ' * 38}"
    pp '-' * 80
    pp " Method  |   First Time (\%)    Mean Suggestions       Failures (\%) #{' ' * 13}"
    pp '-' * 80
  end
end
