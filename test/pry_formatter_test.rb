require_relative 'test_helper'
require 'term/ansicolor'
require 'did_you_mean/pry'

class PryFormatterTest < Minitest::Test
  include Term::ANSIColor

  def setup
    DidYouMean::Pry.enable
  end

  def teardown
    DidYouMean::Pry.disable
  end

  def test_class_name_format
    output = ReplTester.start { input 'Obejct' }

    assert_includes output, red("Did you mean?")
    assert_includes output, blue(underline("Object"))
  end

  def test_method_name_format
    output = ReplTester.start { input 'self.methosd' }

    assert_includes output, red("Did you mean?")
    assert_includes output, " #methods\n"
  end

  def test_instance_variable_name_format
    output = ReplTester.start do
      input '@name = "Yuki"'
      input 'name'
    end

    assert_includes output, red("Did you mean?")
    assert_includes output, yellow("@name")
  end
=begin
  # This test occasionally fails due to a treading issue.
  def test_attribute_name_format
    output = ReplTester.start do
      input 'User.new(flrst_name: "flrst???")'
    end

    assert_includes output, red("Did you mean?")
    assert_includes output, magenta("first_name") + ": string"
  end
=end
end
