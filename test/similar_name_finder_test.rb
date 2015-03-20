require_relative 'test_helper'

class SimilarNameFinderTest < Minitest::Test
  class User
    def initialize
      @email_address = 'email_address@address.net'
    end

    def first_name; end
    def to_s
      "#{@first_name} #{@last_name} <#{email_address}>"
    end

    private

    def cia_codename; "Alexa" end
  end

  module UserModule
    def from_module; end
  end

  @@does_exist = true

  def setup
    user = User.new.extend(UserModule)

    @error_from_instance_method = assert_raises(NAME_ERROR){ user.instance_eval { flrst_name } }
    @error_from_module_method   = assert_raises(NAME_ERROR){ user.instance_eval { fr0m_module } }
    @error_from_missing_at_sign = assert_raises(NAME_ERROR){ user.to_s }

    # Use begin + rescue as #assert_raises changes a scope.
    @error_from_local_variable = begin
      userr
    rescue NAME_ERROR => e
      e
    end

    @error_from_class_variable = assert_raises(NameError){ @@doesnt_exist }
    @error_from_private_method = assert_raises(NAME_ERROR){ user.instance_eval { cia_code_name } }
  end

  def test_similar_words
    assert_suggestion @error_from_instance_method.suggestions, "first_name"
    assert_suggestion @error_from_module_method.suggestions,   "from_module"
    assert_suggestion @error_from_local_variable.suggestions,  "user"
    assert_suggestion @error_from_missing_at_sign.suggestions, "email_address"
    assert_suggestion @error_from_private_method.suggestions,  "cia_codename"

    if RUBY_ENGINE != 'rbx'
      assert_suggestion @error_from_class_variable.suggestions, "does_exist"
    end
  end

  def test_did_you_mean?
    assert_match "Did you mean? #first_name",  @error_from_instance_method.did_you_mean?
    assert_match "Did you mean? #from_module", @error_from_module_method.did_you_mean?
    assert_match "Did you mean? user",         @error_from_local_variable.did_you_mean?
    assert_match "Did you mean? @email_address", @error_from_missing_at_sign.did_you_mean?
    assert_match "Did you mean? #cia_codename",  @error_from_private_method.did_you_mean?

    if RUBY_ENGINE != 'rbx'
      assert_match "Did you mean? @@does_exist", @error_from_class_variable.did_you_mean?
    end
  end
end
