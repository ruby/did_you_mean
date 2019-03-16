# tests TreeSpellCheckerT
class TreeSpellCheckerTest
  describe 'structured dictionary' do
    let(:dictionary) do
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
    end
    let(:test_str) {  'spek/modeks/confirns/viken_spec.rb'  }

    it 'works out suggestions' do
      exp = ["spec/models/concerns/vixen_spec.rb", "spec/models/concerns/vixenus_spec.rb"]
      suggestions = DidYouMean.new(test_str).structured(dictionary)
      expect(suggestions.to_set).to eq exp.to_set
    end

    it 'find out base names in a node' do
      node = 'spec/modals/confirms'
      names = DidYouMean.new(test_str).send(:base_names, node, dictionary)
      expect(names.to_set).to eq %w(abcd_spec.rb efgh_spec.rb).to_set
    end

    it 'works out nodes' do
      exp_paths = ['spec/models/concerns',
                   'spec/models/confirms',
                   'spec/modals/concerns',
                   'spec/modals/confirms',
                   'spec/controllers/concerns',
                   'spec/controllers/confirms'].to_set
      states = DidYouMean.new(test_str).send(:parse, dictionary)
      nodes = states[0].product(*states[1..-1])
      paths = DidYouMean.new(test_str).send(:possible_paths, nodes)
      expect(paths.to_set).to eq exp_paths.to_set
    end

    it 'works out state space' do
      suggestions = DidYouMean.new(test_str).send(:plausible_states, dictionary)
      expect(suggestions).to eq [["spec"], ["models", "modals"], ["confirms", "concerns"]]
    end

    it 'parses dictionary' do
      states = DidYouMean.new(test_str).send(:parse, dictionary)
      expect(states).to eq  [["spec"], ["models", "modals", "controllers"], ["concerns", "confirms"]]
    end
  end
end
