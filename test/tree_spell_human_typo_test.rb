require 'test_helper'

class TreeSpellHumanTypoTest < Minitest::Test
  def setup
    @word = 'spec/services/anything_spec'
    @sh = HumanTypo.new(@word)
    @len = @word.length
  end

  def test_show_corrections
    10.times do
      word_error = HumanTypo.new(@word).call
      refute_match @word, word_error
    end
  end

  def test_deleletion
    assert_match @sh.send(:deletion, 5), 'spec/ervices/anything_spec'
    assert_match @sh.send(:deletion, @len), 'spec/services/anything_spe'
    assert_match @sh.send(:deletion, 0), 'pec/services/anything_spec'
  end

  def test_insertion
    assert_match @sh.send(:insertion, 7, 'X'), 'spec/serXvices/anything_spec'
    assert_match @sh.send(:insertion, 0, 'X'), 'Xspec/services/anything_spec'
    assert_match @sh.send(:insertion, @len - 1, 'X'), 'spec/services/anything_specX'
  end

  def test_transposition
    n = @word.length
    assert_match @sh.send(:transposition, 0, -1), 'psec/services/anything_spec'
    assert_match @sh.send(:transposition, n - 1, +1), 'spec/services/anything_spce'
    assert_match @sh.send(:transposition, 4, +1), 'specs/ervices/anything_spec'
    assert_match @sh.send(:transposition, 4, -1), 'spe/cservices/anything_spec'
    assert_match @sh.send(:transposition, 21, -1), 'spec/services/anythign_spec'
    assert_match @sh.send(:transposition, 21, +1), 'spec/services/anythin_gspec'
  end

  def test_for_change
    refute_match @sh.call, @word
  end
end
