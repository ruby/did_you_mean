require_relative 'test_helper'

class SimilarNameFinderTest < Minitest::Test
  class User
    def initialize(options = {})
      @email = options[:email]
    end

    def call_flrst_name;  f1rst_name; end
    def call_fr0m_module; fr0m_module; end
    def first_name; end
    def to_s
      "#{@first_name} #{@last_name} <#{email}>"
    end
  end

  module UserModule
    def from_module; end
  end

  def setup
    user = User.new.extend(UserModule)

    @error_from_instance_method = assert_raises(NAME_ERROR){ user.call_flrst_name }
    @error_from_module_method   = assert_raises(NAME_ERROR){ user.call_fr0m_module }
    @error_from_missing_at_sign = assert_raises(NAME_ERROR){ user.to_s }

    # Use begin + rescue as #assert_raises changes a scope.
    @error_from_local_variable = begin
      userr
    rescue NAME_ERROR => e
      e
    end
  end

  def test_similar_words
    assert_suggestion @error_from_instance_method.suggestions, "first_name"
    assert_suggestion @error_from_module_method.suggestions,   "from_module"
    assert_suggestion @error_from_local_variable.suggestions,  "user"
    assert_suggestion @error_from_missing_at_sign.suggestions, "email"
  end

  def test_did_you_mean?
    assert_match "Did you mean? #first_name",  @error_from_instance_method.did_you_mean?
    assert_match "Did you mean? #from_module", @error_from_module_method.did_you_mean?
    assert_match "Did you mean? user",         @error_from_local_variable.did_you_mean?
    assert_match "Did you mean? @email",       @error_from_missing_at_sign.did_you_mean?
  end
end
