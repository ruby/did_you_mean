require 'test_helper'

class SpellCheckerTest < Minitest::Test
  class WordCollection
    include DidYouMean::SpellCheckable

    def initialize(words)
      @words = words
    end

    def similar_to(input)
      @corrections, @input = nil, input

      corrections
    end

    def candidates
      { @input => @words }
    end
  end

  def test_similar_to_corrects_mistypes

    assert_correction 'foo',         collection('foo', 'fork')          .similar_to('doo')
    assert_correction 'email',       collection('email', 'fail', 'eval').similar_to('meail')
    assert_correction 'fail',        collection('email', 'fail', 'eval').similar_to('fial')
    assert_correction 'fail',        collection('email', 'fail', 'eval').similar_to('afil')
    assert_correction 'eval',        collection('email', 'fail', 'eval').similar_to('eavl')
    assert_correction 'eval',        collection('email', 'fail', 'eval').similar_to('veal')
    assert_correction 'sub!',        collection('sub', 'gsub', 'sub!')  .similar_to('suv!')
    assert_correction 'sub',         collection('sub', 'gsub', 'sub!')  .similar_to('suv')

    assert_equal %w(gsub! gsub),     collection('sub', 'gsub', 'gsub!').similar_to('gsuv!')
    assert_equal %w(sub! sub gsub!), collection('sub', 'sub!', 'gsub', 'gsub!').similar_to('ssub!')

    group_methods = %w(groups group_url groups_url group_path)
    assert_correction 'groups', collection(group_methods).similar_to('group')

    group_classes = %w(
      GroupMembership
      GroupMembershipPolicy
      GroupMembershipDecorator
      GroupMembershipSerializer
      GroupHelper
      Group
      GroupMailer
      NullGroupMembership
    )

    assert_correction 'GroupMembership',          collection(group_classes).similar_to('GroupMemberhip')
    assert_correction 'GroupMembershipDecorator', collection(group_classes).similar_to('GroupMemberhipDecorator')

    names = %w(first_name_change first_name_changed? first_name_will_change!)
    assert_equal names, collection(names).similar_to('first_name_change!')

    assert_empty collection('proc').similar_to 'product_path'
    assert_empty collection('fork').similar_to 'fooo'
  end

  def test_similar_to_corrects_misspells
    assert_correction 'descendants',      collection('descendants')     .similar_to('dependents')
    assert_correction 'drag_to',          collection('drag_to')         .similar_to('drag')
    assert_correction 'set_result_count', collection('set_result_count').similar_to('set_result')
  end

  def test_similar_to_sorts_results_by_simiarity
    expected = %w(
      name123456
      name12345
      name1234
      name123
    )

    actual = WordCollection.new(%w(
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
    WordCollection.new(args.flatten)
  end
end
