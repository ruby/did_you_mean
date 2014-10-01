require_relative 'test_helper'

class SimilarNameFinderTest < Minitest::Test
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
      from_instance_method: assert_raises(NameError){ user.call_flrst_name },
      from_module_method:   assert_raises(NameError){ user.call_fr0m_module }
    }

    begin
      userr
    rescue NameError => e
      @instance_variable_error = e
    end
  end

  def test_similar_methods
    assert_includes @errors[:from_instance_method].finder.similar_methods, "first_name"
    assert_includes @errors[:from_module_method].finder.similar_methods, "from_module"
  end

  def test_similar_local_variables
    assert_includes @instance_variable_error.finder.similar_local_variables, "user"
  end

  def test_did_you_mean?
    assert_match "Did you mean? #first_name",  @errors[:from_instance_method].did_you_mean?
    assert_match "Did you mean? #from_module", @errors[:from_module_method].did_you_mean?

    assert_match "Did you mean? user", @instance_variable_error.did_you_mean?
  end

  def test_message
    assert_match @errors[:from_instance_method].did_you_mean?, @errors[:from_instance_method].message
    assert_match @errors[:from_module_method].did_you_mean?, @errors[:from_module_method].message
    assert_match @instance_variable_error.did_you_mean?, @instance_variable_error.message
  end
end
