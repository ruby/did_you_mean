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

  def test_file_in_root
    files = Dir['test/**/*.rb']
    word = 'test/spell_checker_test.rb'
    word_error = 'test/spell_checker_test.r'
    suggestions = TreeSpellChecker.new(dictionary: files).correct word_error
    assert_equal word, suggestions.first
  end

  def test_no_plausible_states
    files = Dir['test/**/*.rb']
    word_error = 'testspell_checker_test.rb'
    suggestions = TreeSpellChecker.new(dictionary: files).correct word_error
    assert_equal [], suggestions
  end

  def test_works_out_suggestions
    exp = ['spec/models/concerns/vixen_spec.rb',
           'spec/models/concerns/vixenus_spec.rb']
    suggestions = @tsp.correct(@test_str)
    assert_equal suggestions.to_set, exp.to_set
  end

  def test_works_when_input_is_correct
    correct_input = 'spec/models/concerns/vixenus_spec.rb'
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
