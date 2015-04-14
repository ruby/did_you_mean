require_relative 'test_helper'

class WordCollectionTest < Minitest::Test

  def test_similar_to
    assert_suggestion 'foo',         collection('foo', 'fork')          .similar_to('doo')
    assert_suggestion 'drag_to',     collection('drag_to')              .similar_to('drag')
    assert_suggestion 'descendants', collection('descendants')          .similar_to('dependents')
    assert_suggestion 'email',       collection('email', 'fail', 'eval').similar_to('email')
    assert_suggestion 'fail',        collection('email', 'fail', 'eval').similar_to('fial')
    assert_suggestion 'eval',        collection('email', 'fail', 'eval').similar_to('eavl')
    assert_suggestion 'sub',         collection('sub', 'gsub', 'sub!')  .similar_to('suv')
    assert_suggestion 'sub!',        collection('sub', 'gsub', 'sub!')  .similar_to('suv!')
    assert_suggestion 'gsub!',       collection('sub', 'gsub', 'gsub!') .similar_to('gsuv!')

    assert_suggestion 'and_call_original', collection('and_call_original').similar_to('and_call_through')
    assert_suggestion 'groups', collection(%w(groups group_url groups_url group_path)).similar_to('group')

    assert_empty collection('proc').similar_to 'product_path'
    assert_empty collection('fork').similar_to 'fooo'
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
    DidYouMean::WordCollection.new(args.flatten)
  end
end
