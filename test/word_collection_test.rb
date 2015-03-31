require_relative 'test_helper'

class WordCollectionTest < Minitest::Test
  def test_similar_to_sorts_results_by_simiarity
    expected = %w(
      name123456
      name12345
      name1234
      name123
    )

    actual = DidYouMean::WordCollection.new(%w(
      name12
      name123
      name1234
      name12345
      name123456
    )).similar_to("name123456")

    assert_equal expected, actual
  end
end
