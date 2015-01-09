require_relative 'test_helper'

class SimilarMethodFinderTest < Minitest::Test

  def setup
    user = User.new.extend(UserModule)

    @error_from_instance_method = assert_raises(NoMethodError){ user.flrst_name }
    @error_from_private_method  = assert_raises(NoMethodError){ user.friend }
    @error_from_module_method   = assert_raises(NoMethodError){ user.fr0m_module }
    @error_from_class_method    = assert_raises(NoMethodError){ User.l0ad }
    @error_from_similar_class_method  = assert_raises(NoMethodError){ Users.first_name }
  end

  def test_similar_words
    assert_suggestion @error_from_instance_method.suggestions, "first_name"
    assert_suggestion @error_from_private_method.suggestions,  "friends"
    assert_suggestion @error_from_module_method.suggestions,   "from_module"
    assert_suggestion @error_from_class_method.suggestions,    "load"
    assert_suggestion @error_from_similar_class_method.suggestions,    %w{first_names User.first_name}
  end

  def test_did_you_mean?
    assert_match "Did you mean? #first_name",  @error_from_instance_method.did_you_mean?
    assert_match "Did you mean? #friends",     @error_from_private_method.did_you_mean?
    assert_match "Did you mean? #from_module", @error_from_module_method.did_you_mean?
    assert_match "Did you mean? .load",        @error_from_class_method.did_you_mean?
    assert_match "Did you mean? .first_names\n                  User.first_name",        @error_from_similar_class_method.did_you_mean?
  end

  def test_similar_words_for_long_method_name
    error = assert_raises(NoMethodError){ User.new.dependents }
    assert_suggestion error.suggestions, "descendants"
  end
end

class User
  def friends; end
  def first_name; end
  def descendants; end

  class << self
    def first_name; end
  end

  class << self
    def pass; end
  end

  private

  def friend; end

  class << self
    def load; end
  end
end

module UserModule
  def from_module; end
end

class Users
  class << self
    def first_names; end
  end
end