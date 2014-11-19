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

    @error_from_instance_method = assert_raises(NoMethodError){ user.flrst_name }
    @error_from_private_method  = assert_raises(NoMethodError){ user.friend }
    @error_from_module_method   = assert_raises(NoMethodError){ user.fr0m_module }
    @error_from_class_method    = assert_raises(NoMethodError){ User.l0ad }
  end

  def test_similar_words
    assert_suggestion @error_from_instance_method.finder.suggestions, :first_name
    assert_suggestion @error_from_private_method.finder.suggestions,  :friends
    assert_suggestion @error_from_module_method.finder.suggestions,   :from_module
    assert_suggestion @error_from_class_method.finder.suggestions,    :load
  end

  def test_did_you_mean?
    assert_match "Did you mean? #first_name",  @error_from_instance_method.did_you_mean?
    assert_match "Did you mean? #friends",     @error_from_private_method.did_you_mean?
    assert_match "Did you mean? #from_module", @error_from_module_method.did_you_mean?
    assert_match "Did you mean? .load",        @error_from_class_method.did_you_mean?
  end

  def test_similar_words_for_long_method_name
    error = assert_raises(NoMethodError){ User.new.dependents }
    assert_suggestion error.finder.suggestions, :descendants
  end
end
