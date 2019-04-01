require 'test_helper'

class TreeSpellHumanTypoTest < Minitest::Test
  def setup
    @input = 'spec/services/anything_spec'
    @sh = TreeSpellHumanTypo.new(@input)
    @len = @input.length
  end

  def test_deleletion
    assert_match @sh.deletion_test(5), 'spec/ervices/anything_spec'
    assert_match @sh.deletion_test(@len - 1), 'spec/services/anything_spe'
    assert_match @sh.deletion_test(0), 'pec/services/anything_spec'
  end

  def test_insertion
    assert_match @sh.insertion_test(7, 'X'), 'spec/serXvices/anything_spec'
    assert_match @sh.insertion_test(0, 'X'), 'Xspec/services/anything_spec'
    assert_match @sh.insertion_test(@len - 1, 'X'), 'spec/services/anything_specX'
  end

  def test_transposition
    n = @input.length
    assert_match @sh.transposition_test(0, -1), 'psec/services/anything_spec'
    assert_match @sh.transposition_test(n - 1, +1), 'spec/services/anything_spce'
    assert_match @sh.transposition_test(4, +1), 'specs/ervices/anything_spec'
    assert_match @sh.transposition_test(4, -1), 'spe/cservices/anything_spec'
    assert_match @sh.transposition_test(21, -1), 'spec/services/anythign_spec'
    assert_match @sh.transposition_test(21, +1), 'spec/services/anythin_gspec'
  end

  def test_for_change
    refute_match @sh.call, @input
  end

  def test_check_input
    assert_raises(StandardError) { TreeSpellHumanTypo.new('tiny') }
  end
end
