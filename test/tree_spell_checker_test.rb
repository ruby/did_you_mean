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
    test_str = 'spek/modeks/confirns/viken_spec.rb'
    @tsp = TreeSpellChecker.new(test_str)
  end

  def test_works_out_suggestions
    exp = ["spec/models/concerns/vixen_spec.rb", "spec/models/concerns/vixenus_spec.rb"]
    suggestions = @tsp.structured(@dictionary)
    assert_equal suggestions.to_set, exp.to_set
  end

  def test_find_out_base_names_in_a_node
    node = 'spec/modals/confirms'
    names = @tsp.send(:base_names, node, @dictionary)
    assert_equal names.to_set, %w(abcd_spec.rb efgh_spec.rb).to_set
  end

  def test_works_out_nodes
    exp_paths = ['spec/models/concerns',
                 'spec/models/confirms',
                 'spec/modals/concerns',
                 'spec/modals/confirms',
                 'spec/controllers/concerns',
                 'spec/controllers/confirms'].to_set
    states = @tsp.send(:parse, @dictionary)
    nodes = states[0].product(*states[1..-1])
    paths = @tsp.send(:possible_paths, nodes)
    assert_equal paths.to_set, exp_paths.to_set
  end

  def test_works_out_state_space
    suggestions = @tsp.send(:plausible_states, @dictionary)
    assert_equal suggestions, [["spec"], ["models", "modals"], ["confirms", "concerns"]]
  end

  def test_parses_dictionary
    states = @tsp.send(:parse, @dictionary)
    assert_equal states, [["spec"], ["models", "modals", "controllers"], ["concerns", "confirms"]]
  end
end
