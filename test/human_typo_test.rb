require 'test_helper'

class HumanTypoTest < Minitest::Test
  def setup
    @word = 'spec/services/anything_spec'
    @sh = HumanTypo.new(@word)
  end

  def test_deleletion
    assert_match @sh.send(:deletion, 5), 'spec/ervices/anything_spec'
  end

  def test_insertion
    assert_match @sh.send(:insertion, 7, 'X'), 'spec/serXvices/anything_spec'
  end

  def test_positive_transposition
    n = @word.length
    assert_match @sh.send(:transposition, 0, -1), 'psec/services/anything_spec'
    assert_match @sh.send(:transposition, n, +1), 'spec/services/anything_spce'
    assert_match @sh.send(:transposition, 4, +1), 'specs/ervices/anything_spec'
    assert_match @sh.send(:transposition, 4, -1), 'spe/cservices/anything_spec'
  end

  def test_for_change
    refute_match @sh.call, @word
  end
end
