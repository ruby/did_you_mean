require_relative 'test_helper'

class SimpleSimilarClassFinderTest < Minitest::Test
  def setup
    @error = assert_raises(NameError) { ::Bo0k }
  end

  def test_similar_classes
    assert_nil @error.did_you_mean?
    assert_equal "uninitialized constant Bo0k", @error.message
    assert @error.method_finder.similar_classes.empty?
  end
end
