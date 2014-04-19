require_relative 'test_helper'

class NoMethodErrorExtensionTest < Test::Unit::TestCase
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
      from_instance_method: assert_raise(NoMethodError){ user.flrst_name },
      from_private_method:  assert_raise(NoMethodError){ user.friend },
      from_module_method:   assert_raise(NoMethodError){ user.fr0m_module },
      from_class_method:    assert_raise(NoMethodError){ User.l0ad }
    }
  end

  def test_unknown_attribute_error_with_did_you_mean
    error = assert_raise(ActiveRecord::UnknownAttributeError) do
      ::User.new(flrst_name: "wrong flrst name")
    end

    assert error.method_finder.similar_columns.include?("first_name")
    assert_match "Did you mean? first_name", error.did_you_mean?
    assert_match error.did_you_mean?, error.message
  end

  def test_similar_methods
    assert @errors[:from_instance_method].method_finder.similar_methods.include?(:first_name)
    assert  @errors[:from_private_method].method_finder.similar_methods.include?(:friends)
    assert   @errors[:from_module_method].method_finder.similar_methods.include?(:from_module)
    assert    @errors[:from_class_method].method_finder.similar_methods.include?(:load)
  end

  def test_similar_methods_for_long_method_name
    error = assert_raise(NoMethodError){ User.new.dependents }
    assert error.method_finder.similar_methods.include?(:descendants)
  end

  def test_did_you_mean?
    assert_match "Did you mean? #first_name",  @errors[:from_instance_method].did_you_mean?
    assert_match "Did you mean? #friends",     @errors[:from_private_method].did_you_mean?
    assert_match "Did you mean? #from_module", @errors[:from_module_method].did_you_mean?
    assert_match "Did you mean? .load",        @errors[:from_class_method].did_you_mean?
  end

  def test_message
    assert_match @errors[:from_instance_method].did_you_mean?, @errors[:from_instance_method].message
    assert_match  @errors[:from_private_method].did_you_mean?,  @errors[:from_private_method].message
    assert_match   @errors[:from_module_method].did_you_mean?,   @errors[:from_module_method].message
    assert_match    @errors[:from_class_method].did_you_mean?,    @errors[:from_class_method].message
  end
end
