require 'test_helper'
require 'set'

class TreeSpellCheckerTest  < Minitest::Test

  def setup
    @dictionary = 
      %w(
        spec/models/concerns/vixen_spec.rb
        spec/models/concerns/abcd_spec.rb
        spec/models/concerns/vixenus_spec.rb
        spec/models/concerns/efgh_spec.rb
        spec/modals/confirms/abcd_spec.rb
        spec/modals/confirms/efgh_spec.rb
        spec/models/gafafa_spec.rb
        spec/models/gfsga_spec.rb
        spec/controllers/vixen_controller_spec.rb
      )
    @test_str = 'spek/modeks/confirns/viken_spec.rb'
    @tsp = TreeSpellChecker.new(dictionary: @dictionary)
  end

  def test_human_typo_exercise
    first_times = [0, 0]
    files = Dir["test/**/*.rb"]
    len = files.length
    10.times do
      word = files[rand len]
      word_error = word[0..-2] #HumanTypo.new(word).correct
      suggestions = suggestions word_error, files
  binding.pry unless suggestions.first.first == word
      check_first_is_right(word, suggestions, first_times)
    end
    pp "first_times #{first_times}"
  end

  def test_temp
    files = Dir["test/**/*.rb"]
    word = "test/spell_checking/variable_name_check_test.rb"
    word_error = "test/spell_checking/variable_name_check_test.r"
    suggestions = suggestions word_error, files
    assert_equal suggestions.first.first, word
  end

  def suggestions(word_error, files)
    a0 = TreeSpellChecker.new(dictionary: files).correct word_error
    a1 = ::DidYouMean::SpellChecker.new(dictionary: files).correct word_error
    [a0, a1]
  end

  def check_first_is_right(word, suggestions, first_times)
    suggestions.each_with_index.map do |a, i|
      first_times[i] +=  1 if word == a.first
    end
  end

  def test_works_out_suggestions
    exp = ["spec/models/concerns/vixen_spec.rb", "spec/models/concerns/vixenus_spec.rb"]
    suggestions = @tsp.correct(@test_str)
    assert_equal suggestions.to_set, exp.to_set
  end

  def test_works_when_input_is_correct
    correct_input ='spec/models/concerns/vixenus_spec.rb' 
    suggestions = @tsp.correct correct_input
    assert_equal suggestions.first, correct_input
  end

  def test_find_out_base_names_in_a_node
    node = 'spec/modals/confirms'
    names = @tsp.send(:base_names, node)
    assert_equal names.to_set, %w(abcd_spec.rb efgh_spec.rb).to_set
  end

  def test_works_out_nodes
    exp_paths = ['spec/models/concerns',
                 'spec/models/confirms',
                 'spec/modals/concerns',
                 'spec/modals/confirms',
                 'spec/controllers/concerns',
                 'spec/controllers/confirms'].to_set
    states = @tsp.send(:parse)
    nodes = states[0].product(*states[1..-1])
    paths = @tsp.send(:possible_paths, nodes)
    assert_equal paths.to_set, exp_paths.to_set
  end

  def test_works_out_state_space
    suggestions = @tsp.send(:plausible_states, @test_str)
    assert_equal suggestions, [["spec"], ["models", "modals"], ["confirms", "concerns"]]
  end

  def test_parses_dictionary
    states = @tsp.send(:parse)
    assert_equal states, [["spec"], ["models", "modals", "controllers"], ["concerns", "confirms"]]
  end

  def test_parses_elementary_dictionary
    dictionary = ['spec/models/user_spec.rb', 'spec/services/account_spec.rb']
    tsp = TreeSpellChecker.new(dictionary: dictionary)
    states = tsp.send(:parse)
    assert_equal states, [['spec'], ['models', 'services']]
  end
end
