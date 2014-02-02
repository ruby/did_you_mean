require_relative 'test_helper'

class NoMethodErrorExtensionTest < Test::Unit::TestCase
  class User
    def friends; end
    def first_name; end

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

  def test_similar_methods
    assert @errors[:from_instance_method].similar_methods.include?(:first_name)
    assert @errors[:from_private_method].similar_methods.include?(:friends)
    assert @errors[:from_module_method].similar_methods.include?(:from_module)
    assert @errors[:from_class_method].similar_methods.include?(:load)
  end

  def test_did_you_mean?
    assert_equal "\n\nDid you mean?\n\tNoMethodErrorExtensionTest::User#first_name\n\n", @errors[:from_instance_method].did_you_mean?
    assert_equal "\n\nDid you mean?\n\tNoMethodErrorExtensionTest::User#friends\n\n", @errors[:from_private_method].did_you_mean?
    assert_equal "\n\nDid you mean?\n\tNoMethodErrorExtensionTest::User#from_module\n\n", @errors[:from_module_method].did_you_mean?
    assert_equal "\n\nDid you mean?\n\tNoMethodErrorExtensionTest::User.load\n\n", @errors[:from_class_method].did_you_mean?
  end

  def test_message
    assert_match @errors[:from_instance_method].did_you_mean?, @errors[:from_instance_method].message
    assert_match @errors[:from_private_method].did_you_mean?, @errors[:from_private_method].message
    assert_match @errors[:from_module_method].did_you_mean?, @errors[:from_module_method].message
    assert_match @errors[:from_class_method].did_you_mean?, @errors[:from_class_method].message
  end
end
