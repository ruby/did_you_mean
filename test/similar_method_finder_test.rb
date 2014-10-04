require_relative 'test_helper'

class SimilarMethodFinderTest < Minitest::Test
  class User
    def friends; end
    def first_name; end
    def descendants; end

    private

    def friend; end

    class << self
      def load; end
    end
  end

  module UserModule
    def from_module; end
  end

  def setup
    user = User.new.extend(UserModule)

    @errors = {
      from_instance_method: assert_raises(NoMethodError){ user.flrst_name },
      from_private_method:  assert_raises(NoMethodError){ user.friend },
      from_module_method:   assert_raises(NoMethodError){ user.fr0m_module },
      from_class_method:    assert_raises(NoMethodError){ User.l0ad }
    }
  end

  def test_similar_words
    assert_includes @errors[:from_instance_method].finder.similar_words, :first_name
    assert_includes @errors[:from_private_method].finder.similar_words, :friends
    assert_includes @errors[:from_module_method].finder.similar_words, :from_module
    assert_includes @errors[:from_class_method].finder.similar_words, :load
  end

  def test_similar_words_for_long_method_name
    error = assert_raises(NoMethodError){ User.new.dependents }
    assert_includes error.finder.similar_words, :descendants
  end

  def test_did_you_mean?
    assert_match "Did you mean? #first_name",  @errors[:from_instance_method].did_you_mean?
    assert_match "Did you mean? #friends",     @errors[:from_private_method].did_you_mean?
    assert_match "Did you mean? #from_module", @errors[:from_module_method].did_you_mean?
    assert_match "Did you mean? .load",        @errors[:from_class_method].did_you_mean?
  end

  def test_message
    assert_match @errors[:from_instance_method].did_you_mean?, @errors[:from_instance_method].message
    assert_match @errors[:from_private_method].did_you_mean?,  @errors[:from_private_method].message
    assert_match @errors[:from_module_method].did_you_mean?,   @errors[:from_module_method].message
    assert_match @errors[:from_class_method].did_you_mean?,    @errors[:from_class_method].message
  end
end
