require_relative 'test_helper'

class WordCollectionTest < Minitest::Test

  def test_similar_to
    assert_suggestion 'foo',         collection('foo',                   similar_to: 'doo')
    assert_suggestion 'drag_to',     collection('drag_to',               similar_to: 'drag')
    assert_suggestion 'descendants', collection('descendants',           similar_to: 'dependents')
    assert_suggestion 'email',       collection('email', 'fail', 'eval', similar_to: 'meail')
    assert_suggestion 'email',       collection('email', 'fail', 'eval', similar_to: 'email')

    assert_equal ['sub', 'sub!'], collection('sub', 'gsub', 'sub!', similar_to: 'suv')
  end

  def test_similar_to_sorts_results_by_simiarity
    expected = %w(
      name123456
      name12345
      name1234
      name123
      name12
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

  private

  def collection(*args)
    if args.last.is_a?(Hash)
      options = args.pop
      DidYouMean::WordCollection.new(args).similar_to(options[:similar_to])
    else
      DidYouMean::WordCollection.new(args)
    end
  end
end
