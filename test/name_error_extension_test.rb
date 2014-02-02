require_relative 'test_helper'

class NameErrorExtensionTest < Test::Unit::TestCase
  class User
    def call_flrst_name;  f1rst_name; end
    def call_fr0m_module; fr0m_module; end
    def first_name; end
  end

  module UserModule
    def from_module; end
  end

  def setup
    user = User.new.extend(UserModule)

    @errors = {
      from_instance_method: assert_raise(NameError){ user.call_flrst_name },
      from_module_method:   assert_raise(NameError){ user.call_fr0m_module }
    }

    begin
      userr
    rescue NameError => e
      @instance_variable_error = e
    end
  end

  def test_similar_methods
    assert @errors[:from_instance_method].similar_methods.include?(:first_name)
    assert @errors[:from_module_method].similar_methods.include?(:from_module)
  end

  def test_similar_local_variables
    assert @instance_variable_error.similar_local_variables.include?(:user)
  end

  def test_did_you_mean?
    assert_equal "\n\nDid you mean?\n    instance methods:\n\t#first_name\n\n", @errors[:from_instance_method].did_you_mean?
    assert_equal "\n\nDid you mean?\n    instance methods:\n\t#from_module\n\n", @errors[:from_module_method].did_you_mean?
    assert_equal "\n\nDid you mean?\n    local variables:\n\tuser\n\n", @instance_variable_error.did_you_mean?
  end

  def test_message
    assert_match @errors[:from_instance_method].did_you_mean?, @errors[:from_instance_method].message
    assert_match @errors[:from_module_method].did_you_mean?, @errors[:from_module_method].message
    assert_match @instance_variable_error.did_you_mean?, @instance_variable_error.message
  end
end
