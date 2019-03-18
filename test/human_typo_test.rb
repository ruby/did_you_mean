class HumanTypoTest
  require 'rails_helper'

  describe 'private methods' do
    let(:word) { 'spec/services/anything_spec' }
    let(:sh) { SloppyHuman.new(word) }
    it 'test_exponential', retry: 3 do
      n_repeat = 100000
      locations = n_repeat.times.map { sh.send(:exponential, 0.05) }
      mean_location = locations.sum.to_f / n_repeat
      expect(mean_location.round(0)).to eq 20
    end

    it 'test_action_type', retry: 6 do
      n_repeat = 10000
      action_types = n_repeat.times.map { sh.send(:action_type) }
      tally = Hash.new(0)
      action_types.map do |k|
        tally[k] += 1
      end
      action_mean = tally[:insert].to_f / n_repeat
      expect(action_types.to_set).to eq [:insert, :transpose, :delete].to_set
      expect(action_mean.round(2)).to eq 0.33
    end

    it 'test_toss', retry: 3 do
      n_repeat = 10000
      directions = n_repeat.times.map { sh.send(:toss) }
      directions_mean = directions.sum.to_f / n_repeat
      expect(directions.to_set).to eq [+1, -1].to_set
      expect(directions_mean.round(2)).to eq 0.00
    end

    it 'test_deleletion' do
      expect(sh.send(:deletion, 5)).to eq 'spec/ervices/anything_spec'
    end

    it 'test_insertion' do
      expect(sh.send(:insertion, 7, 'X')).to eq 'spec/serXvices/anything_spec'
    end

    it 'test_positive_transposition' do
      len = word.length
      expect(sh.send(:transposition, 0, -1)).to eq 'psec/services/anything_spec'
      expect(sh.send(:transposition, len, +1)).to eq 'spec/services/anything_spce'
      expect(sh.send(:transposition, 4, +1)).to eq 'specs/ervices/anything_spec'
      expect(sh.send(:transposition, 4, -1)).to eq 'spe/cservices/anything_spec'
    end

    it 'test_call' do
      10.times do
        pp "word", SloppyHuman.new(word).call
      end
    end
  end
end
