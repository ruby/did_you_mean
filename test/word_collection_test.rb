require 'test_helper'

class WordCollectionTest < Minitest::Test

  def test_similar_to
    assert_suggestion 'foo',               collection('foo', 'fork')          .similar_to('doo')
    assert_suggestion 'drag_to',           collection('drag_to')              .similar_to('drag')
    assert_suggestion 'descendants',       collection('descendants')          .similar_to('dependents')
    assert_suggestion 'email',             collection('email', 'fail', 'eval').similar_to('meail')
    assert_suggestion 'fail',              collection('email', 'fail', 'eval').similar_to('fial')
    assert_suggestion 'fail',              collection('email', 'fail', 'eval').similar_to('afil')
    assert_suggestion 'eval',              collection('email', 'fail', 'eval').similar_to('eavl')
    assert_suggestion 'eval',              collection('email', 'fail', 'eval').similar_to('veal')
    assert_suggestion 'sub!',              collection('sub', 'gsub', 'sub!')  .similar_to('suv!')
    assert_suggestion 'set_result_count',  collection('set_result_count')     .similar_to('set_result')

    assert_equal %w(sub),        collection('sub', 'gsub', 'sub!') .similar_to('suv')
    assert_equal %w(gsub! gsub), collection('sub', 'gsub', 'gsub!').similar_to('gsuv!')

    group_methods = %w(groups group_url groups_url group_path)
    assert_suggestion 'groups', collection(group_methods).similar_to('group')

    group_classes = %w(
      GroupMembership
      GroupMembershipPolicy
      GroupMembershipDecorator
      GroupMembershipSerializer
      GroupHelper
      GroupMembershipWithCachedEmailDecorator
      Group
      GroupMailer
      NullGroupMembership
    )

    #assert_suggestion 'GroupMembership',          collection(group_classes).similar_to('GroupMemberhip')
    assert_suggestion 'GroupMembershipDecorator', collection(group_classes).similar_to('GroupMemberhipDecorator')

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
